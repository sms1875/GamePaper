package io.github.sms1875.gamepaper.service;

import io.github.sms1875.gamepaper.domain.Game;
import io.github.sms1875.gamepaper.domain.GameStatus;
import io.github.sms1875.gamepaper.service.firebase.FirebaseUploadService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.concurrent.CompletableFuture;

@Service
public class WallpaperUpdateService {

  private static final Logger logger = LoggerFactory.getLogger(WallpaperUpdateService.class);

  private final Map<String, AbstractGameImageRetrievalService> gameImageServices;
  private final FirebaseUploadService firebaseUploadService;

  public WallpaperUpdateService(Map<String, AbstractGameImageRetrievalService> gameImageServices,
      FirebaseUploadService firebaseUploadService) {
    this.gameImageServices = gameImageServices;
    this.firebaseUploadService = firebaseUploadService;
  }

  public CompletableFuture<Void> updateGameWallpapers(Game game) {
    AbstractGameImageRetrievalService service = gameImageServices.get(game.getName().toLowerCase());
    if (service == null) {
      logger.warn("No image service found for game: {}", game.getName());
      return CompletableFuture.completedFuture(null);
    }

    game.setStatus(GameStatus.UPDATING);
    logger.info("Updating wallpapers for game: {}", game.getName());

    return service.getImageUrlsAsync()
        .thenCompose(urls -> firebaseUploadService.uploadWallpapers(game, urls))
        .exceptionally(ex -> handleUpdateError(game, ex));
  }

  private Void handleUpdateError(Game game, Throwable ex) {
    logger.error("Error updating wallpapers for game: " + game.getName(), ex);
    game.setStatus(GameStatus.FAILED);
    return null;
  }
}
