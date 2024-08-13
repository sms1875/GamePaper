package io.github.sms1875.gamepaper.service;

import io.github.sms1875.gamepaper.domain.Game;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@Service
public class WallpaperUpdateScheduler {
  private static final Logger logger = LoggerFactory.getLogger(WallpaperUpdateScheduler.class);

  private final GameService gameService;
  private final GameWallpaperService gameWallpaperService;

  public WallpaperUpdateScheduler(GameService gameService, GameWallpaperService gameWallpaperService) {
    this.gameService = gameService;
    this.gameWallpaperService = gameWallpaperService;
  }

  @Scheduled(fixedRate = 21600000) // 6 hours in milliseconds
  public void updateWallpapers() {
    logger.info("Starting scheduled wallpaper update");
    List<Game> games = gameService.getAllGames();

    CompletableFuture<Void> updateTask = gameWallpaperService.updateAllGamesWallpapers(games);
    updateTask.thenRun(() -> logger.info("All games updated"))
        .exceptionally(ex -> {
          logger.error("Error during wallpaper update process", ex);
          return null;
        });
  }
}
