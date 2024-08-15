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

  // 설정 상수
  private static final int BATCH_SIZE = 5; // 배치 크기
  private static final int THREAD_POOL_SIZE = 5; // 스레드 풀 크기
  private static final int MAX_RETRIES = 3; // 최대 재시도 횟수
  private static final long RETRY_DELAY_MS = 2000; // 재시도 간격

  private static final ExecutorService executor = Executors.newFixedThreadPool(THREAD_POOL_SIZE);

  private final FirebaseStorageService firebaseStorageService;

  public FirebaseUploadService(FirebaseStorageService firebaseStorageService) {
    this.firebaseStorageService = firebaseStorageService;
  }

  /**
   * 게임의 월페이퍼를 Firebase에 업로드합니다.
   *
   * @param game 게임 객체
   * @param urls 업로드할 이미지 URL 목록
   * @return CompletableFuture<Void> 비동기 작업 결과
   */
  public CompletableFuture<Void> uploadWallpapers(Game game, List<String> urls) {
    if (urls.isEmpty()) {
      handleEmptyWallpapers(game);
      return CompletableFuture.completedFuture(null);
    }

    int currentMaxNumber = getCurrentMaxNumber(game);

    List<String> reversedUrls = reverseUrls(urls);
    AtomicInteger startingNumber = new AtomicInteger(currentMaxNumber + reversedUrls.size());

    return processBatches(game, reversedUrls, startingNumber);
  }

  /**
   * 월페이퍼가 없는 경우 처리
   */
  private void handleEmptyWallpapers(Game game) {
    logger.warn("No wallpapers found for game: {}", game.getName());
    game.setStatus(GameStatus.EMPTY);
  }

  /**
   * 기존 월페이퍼에서 최대 번호를 가져옵니다.
   */
  private int getCurrentMaxNumber(Game game) {
    List<String> existingUrls = firebaseStorageService.getImageUrls(game.getName(), "wallpapers");
    return getMaxNumberFromUrls(existingUrls);
  }

  /**
   * URL 목록을 역순으로 반환합니다.
   */
  private List<String> reverseUrls(List<String> urls) {
    List<String> reversedUrls = new ArrayList<>(urls);
    Collections.reverse(reversedUrls);
    return reversedUrls;
  }

  /**
   * 배치 단위로 월페이퍼를 처리합니다.
   */
  private CompletableFuture<Void> processBatches(Game game, List<String> urls, AtomicInteger startingNumber) {
    List<CompletableFuture<Void>> batchFutures = new ArrayList<>();

    for (int i = 0; i < urls.size(); i += BATCH_SIZE) {
      List<String> batch = urls.subList(i, Math.min(i + BATCH_SIZE, urls.size()));

      CompletableFuture<Void> batchFuture = uploadBatch(game, batch, startingNumber);
      batchFutures.add(batchFuture);

      if (i + BATCH_SIZE < urls.size()) {
        batchFuture.thenCompose(ignored -> delay(RETRY_DELAY_MS));
      }
    }

    return completeAllBatches(game, batchFutures, urls.size());
  }

  /**
   * 배치를 업로드합니다.
   */
  private CompletableFuture<Void> uploadBatch(Game game, List<String> batch, AtomicInteger startingNumber) {
    return CompletableFuture.allOf(
        batch.stream()
            .map(url -> uploadWithRetry(url, game.getName(), startingNumber.getAndDecrement(), 0))
            .toArray(CompletableFuture[]::new))
        .thenRun(() -> logger.info("Uploaded batch of wallpapers for game: {}", game.getName()));
  }

  /**
   * 모든 배치가 완료되면 게임 상태를 업데이트합니다.
   */
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

  /**
   * 비동기적으로 일정 시간 지연
   */
  private CompletableFuture<Void> delay(long millis) {
    return CompletableFuture.runAsync(() -> {
      try {
        Thread.sleep(millis);
      } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
      }
    }, executor);
  }

  /**
   * 재시도를 포함한 이미지 업로드
   */
  private CompletableFuture<Void> uploadWithRetry(String imageUrl, String gameName, int number, int retryCount) {
    return uploadToFirebaseAsync(imageUrl, gameName, number)
        .exceptionally(ex -> handleUploadRetry(imageUrl, gameName, number, retryCount, ex));
  }

  /**
   * 재시도 로직 처리
   */
  private Void handleUploadRetry(String imageUrl, String gameName, int number, int retryCount, Throwable ex) {
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
  }

  /**
   * 비동기적으로 Firebase에 이미지 업로드
   */
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

  /**
   * Firebase에 이미지 업로드
   */
  private void uploadToFirebase(String imageUrl, String gameName, int number) throws IOException, URISyntaxException {
    URI uri = new URI(imageUrl);
    URL url = uri.toURL();
    String fileExtension = getFileExtension(imageUrl);
    String fileName = number + "#" + fileExtension;

    try (var inputStream = url.openStream()) {
      byte[] imageData = inputStream.readAllBytes();
      firebaseStorageService.uploadFile(imageData, fileName, gameName, "wallpapers");
    }
  }

  /**
   * URL에서 파일 확장자를 추출합니다.
   */
  private String getFileExtension(String imageUrl) {
    return imageUrl.substring(imageUrl.lastIndexOf('.'));
  }

  /**
   * 기존 URL에서 최대 번호 추출
   */
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

  /**
   * ExecutorService 종료
   */
  public void shutdownExecutor() throws InterruptedException {
    executor.shutdown();
    if (!executor.awaitTermination(60, TimeUnit.SECONDS)) {
      executor.shutdownNow();
    }
  }
}
