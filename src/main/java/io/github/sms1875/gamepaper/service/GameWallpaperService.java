package io.github.sms1875.gamepaper.service;

import io.github.sms1875.gamepaper.domain.Game;
import io.github.sms1875.gamepaper.domain.GameStatus;
import io.github.sms1875.gamepaper.service.firebase.FirebaseUploadService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

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

  /**
   * 모든 게임의 월페이퍼를 업데이트합니다.
   *
   * @param games 업데이트할 게임 목록
   * @return 비동기 작업을 나타내는 CompletableFuture 객체
   */
  public CompletableFuture<Void> updateAllGamesWallpapers(List<Game> games) {
    return CompletableFuture.allOf(
        games.stream()
            .map(this::updateGameWallpapers)
            .toArray(CompletableFuture[]::new));
  }

  /**
   * 특정 게임의 월페이퍼를 업데이트합니다.
   *
   * @param game 업데이트할 게임 객체
   * @return 비동기 작업을 나타내는 CompletableFuture 객체
   */
  public CompletableFuture<Void> updateGameWallpapers(Game game) {
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

  /**
   * 업데이트 중 에러가 발생했을 때 처리하는 메서드입니다.
   *
   * @param game 에러가 발생한 게임 객체
   * @param ex   발생한 예외
   * @return null을 반환합니다.
   */
  private Void handleUpdateError(Game game, Throwable ex) {
    logger.error("Error updating wallpapers for game: " + game.getName(), ex);
    game.setStatus(GameStatus.EMPTY);
    return null;
  }
}
