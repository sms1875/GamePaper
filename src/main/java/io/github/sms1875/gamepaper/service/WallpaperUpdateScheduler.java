package io.github.sms1875.gamepaper.service;

import io.github.sms1875.gamepaper.domain.Game;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WallpaperUpdateScheduler {

  private static final Logger logger = LoggerFactory.getLogger(WallpaperUpdateScheduler.class);

  private final GameManagementService gameManagementService;
  private final WallpaperUpdateService wallpaperUpdateService;

  public WallpaperUpdateScheduler(GameManagementService gameManagementService,
      WallpaperUpdateService wallpaperUpdateService) {
    this.gameManagementService = gameManagementService;
    this.wallpaperUpdateService = wallpaperUpdateService;
  }

  @Scheduled(fixedRate = 21600000) // 6 hours in milliseconds
  public void updateWallpapers() {
    logger.info("Starting sequential wallpaper update process.");
    List<Game> games = gameManagementService.getAllGames();
    updateGamesSequentially(games, 0);
  }

  private void updateGamesSequentially(List<Game> games, int index) {
    if (index < games.size()) {
      Game game = games.get(index);
      logger.info("Processing game: {}", game.getName());

      wallpaperUpdateService.updateGameWallpapers(game).thenRun(() -> {
        logger.info("Finished processing game: {}", game.getName());
        updateGamesSequentially(games, index + 1); // 다음 게임 처리
      }).exceptionally(ex -> {
        logger.error("Error processing game: " + game.getName(), ex);
        updateGamesSequentially(games, index + 1); // 에러 발생 시에도 다음 게임으로 이동
        return null;
      });
    } else {
      logger.info("All games have been processed.");
    }
  }
}
