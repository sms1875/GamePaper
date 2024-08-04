package io.github.sms1875.gamepaper.service;

import io.github.sms1875.gamepaper.service.firebase.FirebaseStorageService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.net.URL;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

@Service
public class WallpaperUpdateScheduler {
  private static final Logger logger = LoggerFactory.getLogger(WallpaperUpdateScheduler.class);

  private final GameService gameService;
  private final Map<String, GameImageRetrievalService> gameImageServices;
  private final WallpaperCacheService cacheService;
  private final FirebaseStorageService firebaseStorageService;

  public WallpaperUpdateScheduler(GameService gameService, Map<String, GameImageRetrievalService> gameImageServices,
      WallpaperCacheService cacheService, FirebaseStorageService firebaseStorageService) {
    this.gameService = gameService;
    this.gameImageServices = gameImageServices;
    this.cacheService = cacheService;
    this.firebaseStorageService = firebaseStorageService;
  }

  @Scheduled(fixedRate = 21600000) // 6 hours in milliseconds
  public void updateWallpapers() {
    logger.info("Starting scheduled wallpaper update");
    List<GameService.Game> games = gameService.getAllGames();
    updateGameWallpapersSequentially(games);
  }

  private void updateGameWallpapersSequentially(List<GameService.Game> games) {
    CompletableFuture<Void> future = CompletableFuture.completedFuture(null);

    for (GameService.Game game : games) {
      future = future.thenCompose(ignored -> updateGameWallpapers(game));
    }

    future.thenRun(() -> logger.info("All games updated"))
        .exceptionally(ex -> {
          logger.error("Error updating one or more games", ex);
          return null;
        });
  }

  public CompletableFuture<Void> updateGameWallpapers(GameService.Game game) {
    GameImageRetrievalService service = gameImageServices.get(game.getName().toLowerCase());
    if (service != null) {
      game.setStatus(GameService.GameStatus.UPDATING);
      logger.info("Updating wallpapers for game: {}", game.getName());
      return CompletableFuture.supplyAsync(service::getImageUrls)
          .thenAccept(urls -> {
            if (urls.isEmpty()) {
              logger.warn("No wallpapers found for game: {}", game.getName());
              game.setStatus(GameService.GameStatus.EMPTY);
            } else {
              cacheService.cacheWallpapers(game.getName(), urls);
              urls.forEach(url -> uploadToFirebase(url, game.getName()));
              logger.info("Updated {} wallpapers for game: {}", urls.size(), game.getName());
              game.setStatus(GameService.GameStatus.COMPLETED);
            }
          })
          .exceptionally(ex -> {
            logger.error("Error updating wallpapers for game: " + game.getName(), ex);
            game.setStatus(GameService.GameStatus.EMPTY);
            return null;
          });
    } else {
      logger.warn("No image service found for game: {}", game.getName());
      return CompletableFuture.completedFuture(null);
    }
  }

  private void uploadToFirebase(String imageUrl, String gameName) {
    try {
      URL url = new URL(imageUrl);
      String fileName = imageUrl.substring(imageUrl.lastIndexOf('/') + 1);
      byte[] imageData = url.openStream().readAllBytes();

      firebaseStorageService.uploadFile(imageData, fileName, gameName, "wallpapers");
    } catch (IOException e) {
      logger.error("Error uploading image to Firebase for game: " + gameName, e);
    }
  }
}
