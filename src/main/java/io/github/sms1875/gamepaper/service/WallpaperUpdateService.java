package io.github.sms1875.gamepaper.service;

import io.github.sms1875.gamepaper.domain.Game;
import io.github.sms1875.gamepaper.domain.GameStatus;
import io.github.sms1875.gamepaper.service.firebase.FirebaseUploadService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.awt.image.BufferedImage;
import java.net.URL;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import javax.imageio.ImageIO;

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
        .thenApply(urls -> filterPortraitImages(urls)) // 가로보다 세로가 긴 이미지만 필터링
        .thenCompose(filteredUrls -> firebaseUploadService.uploadWallpapers(game, filteredUrls))
        .exceptionally(ex -> handleUpdateError(game, ex));
  }

  /**
   * 가로보다 세로가 긴 이미지만 필터링합니다.
   *
   * @param urls 이미지 URL 목록
   * @return 세로가 더 긴 이미지 URL 목록
   */
  private List<String> filterPortraitImages(List<String> urls) {
    return urls.stream()
        .filter(this::isPortraitImage)
        .toList(); // Java 16+에서 사용 가능, Java 8 이상에서는 Collectors.toList() 사용
  }

  /**
   * 이미지가 세로가 더 긴지 확인합니다.
   *
   * @param imageUrl 이미지 URL
   * @return 세로가 더 길면 true, 그렇지 않으면 false
   */
  private boolean isPortraitImage(String imageUrl) {
    try {
      BufferedImage image = ImageIO.read(new URL(imageUrl));
      return image != null && image.getHeight() > image.getWidth();
    } catch (Exception e) {
      logger.error("Failed to load image from URL: {}", imageUrl, e);
      return false; // 오류가 발생한 이미지는 필터링하지 않음
    }
  }

  private Void handleUpdateError(Game game, Throwable ex) {
    logger.error("Error updating wallpapers for game: " + game.getName(), ex);
    game.setStatus(GameStatus.FAILED);
    return null;
  }
}
