package io.github.sms1875.gamepaper.service.firebase;

import io.github.sms1875.gamepaper.domain.Game;
import io.github.sms1875.gamepaper.domain.GameStatus;
import io.github.sms1875.gamepaper.service.WallpaperProcessingService.ProcessedImage;
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
import java.util.concurrent.TimeUnit;

@Service
public class FirebaseUploadService {

  private static final Logger logger = LoggerFactory.getLogger(FirebaseUploadService.class);

  // 설정 상수
  private static final int BATCH_SIZE = 5;
  private static final int THREAD_POOL_SIZE = 5;
  private static final int MAX_RETRIES = 3;
  private static final long RETRY_DELAY_MS = 2000;

  private static final ExecutorService executor = Executors.newFixedThreadPool(THREAD_POOL_SIZE);

  private final FirebaseStorageService firebaseStorageService;

  public FirebaseUploadService(FirebaseStorageService firebaseStorageService) {
    this.firebaseStorageService = firebaseStorageService;
  }

  public CompletableFuture<Void> uploadWallpapers(Game game, List<ProcessedImage> processedImages) {
    if (processedImages.isEmpty()) {
      handleEmptyWallpapers(game);
      return CompletableFuture.completedFuture(null);
    }

    return processBatches(game, processedImages);
  }

  private void handleEmptyWallpapers(Game game) {
    logger.warn("No wallpapers found for game: {}", game.getName());
    game.setStatus(GameStatus.EMPTY);
  }

  private CompletableFuture<Void> processBatches(Game game, List<ProcessedImage> processedImages) {
    List<CompletableFuture<Void>> batchFutures = new ArrayList<>();

    for (int i = 0; i < processedImages.size(); i += BATCH_SIZE) {
      List<ProcessedImage> batch = processedImages.subList(i, Math.min(i + BATCH_SIZE, processedImages.size()));

      CompletableFuture<Void> batchFuture = uploadBatch(game, batch);
      batchFutures.add(batchFuture);

      if (i + BATCH_SIZE < processedImages.size()) {
        batchFuture.thenCompose(ignored -> delay(RETRY_DELAY_MS));
      }
    }

    return completeAllBatches(game, batchFutures, processedImages.size());
  }

  private CompletableFuture<Void> uploadBatch(Game game, List<ProcessedImage> batch) {
    return CompletableFuture.allOf(
        batch.stream()
            .map(processedImage -> uploadWithRetry(processedImage, game.getName(), 0))
            .toArray(CompletableFuture[]::new))
        .thenRun(() -> logger.info("Uploaded batch of wallpapers for game: {}", game.getName()));
  }

  private CompletableFuture<Void> completeAllBatches(Game game, List<CompletableFuture<Void>> batchFutures,
      int totalWallpapers) {
    return CompletableFuture.allOf(batchFutures.toArray(new CompletableFuture[0]))
        .thenRun(() -> {
          logger.info("Updated {} wallpapers for game: {}", totalWallpapers, game.getName());
          game.setStatus(GameStatus.COMPLETED);
        }).exceptionally(ex -> {
          logger.error("Failed to upload wallpapers for game: {}", game.getName(), ex);
          game.setStatus(GameStatus.FAILED);
          return null;
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

  private CompletableFuture<Void> uploadWithRetry(ProcessedImage processedImage, String gameName, int retryCount) {
    return uploadToFirebaseAsync(processedImage, gameName)
        .exceptionally(ex -> handleUploadRetry(processedImage, gameName, retryCount, ex));
  }

  private Void handleUploadRetry(ProcessedImage processedImage, String gameName, int retryCount, Throwable ex) {
    if (retryCount < MAX_RETRIES) {
      logger.warn("Retrying upload for image: {} (attempt {}/{})", processedImage.getUrl(), retryCount + 1,
          MAX_RETRIES);
      try {
        Thread.sleep(RETRY_DELAY_MS);
      } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
      }
      return uploadWithRetry(processedImage, gameName, retryCount + 1).join();
    } else {
      logger.error("Failed to upload image after {} attempts: {}", MAX_RETRIES, processedImage.getUrl(), ex);
      throw new RuntimeException("Max retries exceeded", ex);
    }
  }

  private CompletableFuture<Void> uploadToFirebaseAsync(ProcessedImage processedImage, String gameName) {
    return CompletableFuture.runAsync(() -> {
      try {
        uploadToFirebase(processedImage, gameName);
      } catch (IOException | URISyntaxException e) {
        logger.error("Error uploading image to Firebase for game: " + gameName, e);
        throw new RuntimeException(e);
      }
    }, executor);
  }

  private void uploadToFirebase(ProcessedImage processedImage, String gameName) throws IOException, URISyntaxException {
    URI uri = new URI(processedImage.getUrl());
    URL url = uri.toURL();
    String fileExtension = getFileExtension(processedImage.getUrl());

    String fileName = processedImage.getNumberWithBlurhash() + fileExtension;

    try (var inputStream = url.openStream()) {
      byte[] imageData = inputStream.readAllBytes();
      firebaseStorageService.uploadFile(imageData, fileName, gameName, "wallpapers");
    }
  }

  private String getFileExtension(String imageUrl) {
    return imageUrl.substring(imageUrl.lastIndexOf('.'));
  }

  public void shutdownExecutor() throws InterruptedException {
    executor.shutdown();
    if (!executor.awaitTermination(60, TimeUnit.SECONDS)) {
      executor.shutdownNow();
    }
  }
}