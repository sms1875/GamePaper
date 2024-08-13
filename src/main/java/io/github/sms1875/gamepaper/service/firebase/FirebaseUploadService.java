package io.github.sms1875.gamepaper.service.firebase;

import io.github.sms1875.gamepaper.domain.Game;
import io.github.sms1875.gamepaper.domain.GameStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Service
public class FirebaseUploadService {

  private static final Logger logger = LoggerFactory.getLogger(FirebaseUploadService.class);
  private static final int BATCH_SIZE = 20; // 배치 크기 설정
  private static final ExecutorService executor = Executors.newFixedThreadPool(10); // 고정된 스레드 풀 사용

  private final FirebaseStorageService firebaseStorageService;

  public FirebaseUploadService(FirebaseStorageService firebaseStorageService) {
    this.firebaseStorageService = firebaseStorageService;
  }

  public CompletableFuture<Void> uploadWallpapers(Game game, List<String> urls) {
    if (urls.isEmpty()) {
      logger.warn("No wallpapers found for game: {}", game.getName());
      game.setStatus(GameStatus.EMPTY);
      return CompletableFuture.completedFuture(null);
    }

    List<CompletableFuture<Void>> batchFutures = new ArrayList<>();

    for (int i = 0; i < urls.size(); i += BATCH_SIZE) {
      List<String> batch = urls.subList(i, Math.min(i + BATCH_SIZE, urls.size()));

      CompletableFuture<Void> batchFuture = CompletableFuture.allOf(
          batch.stream()
              .map(url -> CompletableFuture.runAsync(() -> uploadToFirebase(url, game.getName()), executor))
              .toArray(CompletableFuture[]::new))
          .thenRun(() -> logger.info("Uploaded batch of wallpapers for game: {}", game.getName()));

      batchFutures.add(batchFuture);

      if (i + BATCH_SIZE < urls.size()) {
        batchFuture.thenCompose(ignored -> delay(2000)); // 비동기적으로 2초 대기
      }
    }

    return CompletableFuture.allOf(batchFutures.toArray(new CompletableFuture[0]))
        .thenRun(() -> {
          logger.info("Updated {} wallpapers for game: {}", urls.size(), game.getName());
          game.setStatus(GameStatus.COMPLETED);
        });
  }

  private CompletableFuture<Void> delay(long millis) {
    return CompletableFuture.runAsync(() -> {
      try {
        Thread.sleep(millis);
      } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
      }
    }, executor);
  }

  private void uploadToFirebase(String imageUrl, String gameName) {
    try {
      URI uri = new URI(imageUrl);
      URL url = uri.toURL(); // Convert URI to URL
      String fileName = imageUrl.substring(imageUrl.lastIndexOf('/') + 1);

      try (var inputStream = url.openStream()) {
        byte[] imageData = inputStream.readAllBytes();
        firebaseStorageService.uploadFile(imageData, fileName, gameName, "wallpapers");
      }
    } catch (IOException | URISyntaxException e) {
      logger.error("Error uploading image to Firebase for game: " + gameName, e);
    }
  }
}
