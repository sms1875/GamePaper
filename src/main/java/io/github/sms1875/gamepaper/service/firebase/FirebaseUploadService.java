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
import java.util.Collections;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class FirebaseUploadService {

  private static final Logger logger = LoggerFactory.getLogger(FirebaseUploadService.class);

  // AWS 프리티어 환경에 맞춘 설정
  private static final int BATCH_SIZE = 5; // 배치 크기 설정
  private static final int THREAD_POOL_SIZE = 5; // 고정된 스레드 풀 사용
  private static final int MAX_RETRIES = 3; // 최대 재시도 횟수
  private static final long RETRY_DELAY_MS = 2000; // 재시도 지연 시간
  private static final ExecutorService executor = Executors.newFixedThreadPool(THREAD_POOL_SIZE);

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

    // Fetch existing wallpapers to determine current max number
    List<String> existingUrls = firebaseStorageService.getImageUrls(game.getName(), "wallpapers");
    int currentMaxNumber = getMaxNumberFromUrls(existingUrls);

    // 월페이퍼 리스트를 뒤집어 최신 항목이 먼저 업로드되도록 설정
    List<String> reversedUrls = new ArrayList<>(urls);
    Collections.reverse(reversedUrls);

    List<CompletableFuture<Void>> batchFutures = new ArrayList<>();

    // Use AtomicInteger to mutate the starting number in the lambda
    AtomicInteger startingNumber = new AtomicInteger(currentMaxNumber + reversedUrls.size());

    for (int i = 0; i < reversedUrls.size(); i += BATCH_SIZE) {
      List<String> batch = reversedUrls.subList(i, Math.min(i + BATCH_SIZE, reversedUrls.size()));

      CompletableFuture<Void> batchFuture = CompletableFuture.allOf(
          batch.stream()
              .map(url -> uploadWithRetry(url, game.getName(), startingNumber.getAndDecrement(), 0)) // Numbering
              .toArray(CompletableFuture[]::new))
          .thenRun(() -> logger.info("Uploaded batch of wallpapers for game: {}", game.getName()));

      batchFutures.add(batchFuture);

      if (i + BATCH_SIZE < reversedUrls.size()) {
        batchFuture.thenCompose(ignored -> delay(1000)); // 비동기적으로 1초 대기
      }
    }

    return CompletableFuture.allOf(batchFutures.toArray(new CompletableFuture[0]))
        .thenRun(() -> {
          logger.info("Updated {} wallpapers for game: {}", urls.size(), game.getName());
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

  private CompletableFuture<Void> uploadWithRetry(String imageUrl, String gameName, int number, int retryCount) {
    return uploadToFirebaseAsync(imageUrl, gameName, number)
        .exceptionally(ex -> {
          if (retryCount < MAX_RETRIES) {
            logger.warn("Retrying upload for image: {} (attempt {}/{})", imageUrl, retryCount + 1, MAX_RETRIES);
            try {
              Thread.sleep(RETRY_DELAY_MS);
            } catch (InterruptedException e) {
              Thread.currentThread().interrupt();
            }
            return uploadWithRetry(imageUrl, gameName, number, retryCount + 1).join();
          } else {
            logger.error("Failed to upload image after {} attempts: {}", MAX_RETRIES, imageUrl, ex);
            throw new RuntimeException("Max retries exceeded", ex);
          }
        });
  }

  private CompletableFuture<Void> uploadToFirebaseAsync(String imageUrl, String gameName, int number) {
    return CompletableFuture.runAsync(() -> {
      try {
        uploadToFirebase(imageUrl, gameName, number);
      } catch (IOException | URISyntaxException e) {
        logger.error("Error uploading image to Firebase for game: " + gameName, e);
        throw new RuntimeException(e);
      }
    }, executor);
  }

  private void uploadToFirebase(String imageUrl, String gameName, int number) throws IOException, URISyntaxException {
    URI uri = new URI(imageUrl);
    URL url = uri.toURL(); // Convert URI to URL
    String fileExtension = imageUrl.substring(imageUrl.lastIndexOf('.'));
    String fileName = number + "#" + fileExtension; // Numbered file name

    try (var inputStream = url.openStream()) {
      byte[] imageData = inputStream.readAllBytes();
      firebaseStorageService.uploadFile(imageData, fileName, gameName, "wallpapers");
    }
  }

  private int getMaxNumberFromUrls(List<String> urls) {
    int maxNumber = 0;
    Pattern pattern = Pattern.compile("(\\d+)#");

    for (String url : urls) {
      Matcher matcher = pattern.matcher(url);
      if (matcher.find()) {
        int number = Integer.parseInt(matcher.group(1));
        if (number > maxNumber) {
          maxNumber = number;
        }
      }
    }
    return maxNumber;
  }

  public void shutdownExecutor() throws InterruptedException {
    executor.shutdown();
    if (!executor.awaitTermination(60, TimeUnit.SECONDS)) {
      executor.shutdownNow();
    }
  }
}
