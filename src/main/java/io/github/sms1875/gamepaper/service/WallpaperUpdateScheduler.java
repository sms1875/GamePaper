package io.github.sms1875.gamepaper.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
public class WallpaperUpdateScheduler {

  private static final Logger logger = LoggerFactory.getLogger(WallpaperUpdateScheduler.class);

  private final GameService gameService;
  private final GameWallpaperService gameWallpaperService;

  public WallpaperUpdateScheduler(GameService gameService, GameWallpaperService gameWallpaperService) {
    this.gameService = gameService;
    this.gameWallpaperService = gameWallpaperService;
  }

  /**
   * 6시간마다 게임의 월페이퍼를 순차적으로 업데이트하는 작업을 실행합니다.
   */
  @Scheduled(fixedRate = 21600000) // 6 hours in milliseconds
  public void updateWallpapers() {
    logger.info("Starting sequential wallpaper update process.");
    gameService.startSequentialProcessing(gameWallpaperService);
  }
}
