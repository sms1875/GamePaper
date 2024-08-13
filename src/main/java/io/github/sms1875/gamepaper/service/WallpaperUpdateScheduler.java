package io.github.sms1875.gamepaper.service;

import io.github.sms1875.gamepaper.service.firebase.FirebaseStorageService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.net.URL;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

@Service
public class WallpaperUpdateScheduler {
  private static final Logger logger = LoggerFactory.getLogger(WallpaperUpdateScheduler.class);

  private final GameService gameService;
  private final Map<String, AbstractGameImageRetrievalService> gameImageServices;
  private final FirebaseStorageService firebaseStorageService;

  public WallpaperUpdateScheduler(GameService gameService,
      Map<String, AbstractGameImageRetrievalService> gameImageServices,
      FirebaseStorageService firebaseStorageService) {
    this.gameService = gameService;
    this.gameImageServices = gameImageServices;
    this.firebaseStorageService = firebaseStorageService;
  }

  @Scheduled(fixedRate = 21600000) // 6 hours in milliseconds
  public void updateWallpapers() {
    logger.info("Starting scheduled wallpaper update");
    List<GameService.Game> games = gameService.getAllGames();
    updateGameWallpapersSequentially(games)
        .thenRun(() -> logger.info("All games updated"))
        .exceptionally(ex -> {
          logger.error("Error during wallpaper update process", ex);
          return null;
        });
  }

  private CompletableFuture<Void> updateGameWallpapersSequentially(List<GameService.Game> games) {
    return games.stream()
        .reduce(CompletableFuture.completedFuture(null),
            (future, game) -> future.thenCompose(ignored -> updateGameWallpapers(game)),
            (f1, f2) -> f1.thenCompose(ignored -> f2));
  }

  public CompletableFuture<Void> updateGameWallpapers(GameService.Game game) {
    AbstractGameImageRetrievalService service = gameImageServices.get(game.getName().toLowerCase());
    if (service == null) {
      logger.warn("No image service found for game: {}", game.getName());
      return CompletableFuture.completedFuture(null);
    }

    game.setStatus(GameService.GameStatus.UPDATING);
    logger.info("Updating wallpapers for game: {}", game.getName());

    return CompletableFuture.supplyAsync(service::getImageUrls)
        .thenCompose(urls -> processWallpapers(game, urls))
        .exceptionally(ex -> handleUpdateError(game, ex));
  }

  private CompletableFuture<Void> processWallpapers(GameService.Game game, List<String> urls) {
    if (urls.isEmpty()) {
      logger.warn("No wallpapers found for game: {}", game.getName());
      game.setStatus(GameService.GameStatus.EMPTY);
      return CompletableFuture.completedFuture(null);
    }

    return CompletableFuture.allOf(
        urls.stream()
            .map(url -> CompletableFuture.runAsync(() -> uploadToFirebase(url, game.getName())))
            .toArray(CompletableFuture[]::new))
        .thenRun(() -> {
          logger.info("Updated {} wallpapers for game: {}", urls.size(), game.getName());
          game.setStatus(GameService.GameStatus.COMPLETED);
        });
  }

  private Void handleUpdateError(GameService.Game game, Throwable ex) {
    logger.error("Error updating wallpapers for game: " + game.getName(), ex);
    game.setStatus(GameService.GameStatus.EMPTY);
    return null;
  }

  private void uploadToFirebase(String imageUrl, String gameName) {
    try {
      URI uri = new URI(imageUrl);
      URL url = uri.toURL(); // Convert URI to URL
      String fileName = imageUrl.substring(imageUrl.lastIndexOf('/') + 1);
      byte[] imageData = url.openStream().readAllBytes();

      firebaseStorageService.uploadFile(imageData, fileName, gameName, "wallpapers");
    } catch (IOException | URISyntaxException e) {
      logger.error("Error uploading image to Firebase for game: " + gameName, e);
    }
  }
}