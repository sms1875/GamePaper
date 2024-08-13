package io.github.sms1875.gamepaper.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import io.github.sms1875.gamepaper.domain.Game;
import io.github.sms1875.gamepaper.domain.GameStatus;
import io.github.sms1875.gamepaper.service.firebase.FirebaseUploadService;

import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

@Service
public class GameWallpaperService {
  private static final Logger logger = LoggerFactory.getLogger(GameWallpaperService.class);

  private final Map<String, AbstractGameImageRetrievalService> gameImageServices;
  private final FirebaseUploadService firebaseUploadService;

  public GameWallpaperService(Map<String, AbstractGameImageRetrievalService> gameImageServices,
      FirebaseUploadService firebaseUploadService) {
    this.gameImageServices = gameImageServices;
    this.firebaseUploadService = firebaseUploadService;
  }

  public CompletableFuture<Void> updateAllGamesWallpapers(List<Game> games) {
    return games.stream()
        .reduce(CompletableFuture.completedFuture(null),
            (future, game) -> future.thenCompose(ignored -> updateGameWallpapers(game)),
            (f1, f2) -> f1.thenCompose(ignored -> f2));
  }

  private CompletableFuture<Void> updateGameWallpapers(Game game) {
    AbstractGameImageRetrievalService service = gameImageServices.get(game.getName().toLowerCase());
    if (service == null) {
      logger.warn("No image service found for game: {}", game.getName());
      return CompletableFuture.completedFuture(null);
    }

    game.setStatus(GameStatus.UPDATING);
    logger.info("Updating wallpapers for game: {}", game.getName());

    return CompletableFuture.supplyAsync(service::getImageUrls)
        .thenCompose(urls -> firebaseUploadService.uploadWallpapers(game, urls))
        .exceptionally(ex -> handleUpdateError(game, ex));
  }

  private Void handleUpdateError(Game game, Throwable ex) {
    logger.error("Error updating wallpapers for game: " + game.getName(), ex);
    game.setStatus(GameStatus.EMPTY);
    return null;
  }
}
