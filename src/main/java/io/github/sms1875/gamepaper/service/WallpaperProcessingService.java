package io.github.sms1875.gamepaper.service;

import io.trbl.blurhash.BlurHash;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.net.URL;
import java.util.Base64;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Service
public class WallpaperProcessingService {

  private static final Logger logger = LoggerFactory.getLogger(WallpaperProcessingService.class);

  // 스레드 풀 관리
  private static final int THREAD_POOL_SIZE = 5;
  private static final ExecutorService executor = Executors.newFixedThreadPool(THREAD_POOL_SIZE);

  public List<ProcessedImage> processImages(List<String> urls) {
    List<CompletableFuture<ProcessedImage>> futures = IntStream.range(0, urls.size())
        .mapToObj(index -> CompletableFuture.supplyAsync(() -> processImage(urls.get(index), index), executor))
        .collect(Collectors.toList());

    return futures.stream()
        .map(CompletableFuture::join)
        .filter(result -> result != null)
        .sorted((a, b) -> Integer.compare(a.getIndex(), b.getIndex()))
        .collect(Collectors.toList());
  }

  private ProcessedImage processImage(String url, int index) {
    if (!isPortraitImage(url)) {
      return null;
    }
    String blurhash = base64Encode(generateBlurhash(url));
    return new ProcessedImage(url, String.format("%03d#%s", index + 1, blurhash), index);
  }

  // 이미지가 세로형인지 확인하는 메소드
  private boolean isPortraitImage(String imageUrl) {
    try {
      URL url = new URL(imageUrl);
      try (ImageInputStream iis = ImageIO.createImageInputStream(url.openStream())) {
        ImageReader reader = getImageReader(iis, imageUrl);
        if (reader == null) {
          return false;
        }
        return isPortrait(reader);
      }
    } catch (IOException e) {
      logger.error("Failed to load image from URL: {}", imageUrl, e);
      return false;
    }
  }

  // BlurHash 생성 메소드
  private String generateBlurhash(String imageUrl) {
    try {
      URL url = new URL(imageUrl);
      try (ImageInputStream iis = ImageIO.createImageInputStream(url.openStream())) {
        ImageReader reader = getImageReader(iis, imageUrl);
        if (reader == null) {
          return "";
        }
        BufferedImage img = reader.read(0);
        return BlurHash.encode(img, 4, 3);
      }
    } catch (IOException e) {
      logger.error("Failed to generate Blurhash for URL: {}", imageUrl, e);
      return "";
    }
  }

  // Base64로 BlurHash를 인코딩하는 메소드
  private String base64Encode(String blurhash) {
    return Base64.getUrlEncoder().encodeToString(blurhash.getBytes()); // URL-safe Base64 인코딩
  }

  // 공통적으로 사용되는 ImageReader 추출 메소드
  private ImageReader getImageReader(ImageInputStream iis, String imageUrl) {
    Iterator<ImageReader> readers = ImageIO.getImageReaders(iis);
    if (!readers.hasNext()) {
      logger.warn("No image reader found for URL: {}", imageUrl);
      return null;
    }
    ImageReader reader = readers.next();
    reader.setInput(iis);
    return reader;
  }

  // 이미지가 세로형인지 확인하는 로직
  private boolean isPortrait(ImageReader reader) throws IOException {
    int width = reader.getWidth(0);
    int height = reader.getHeight(0);
    return height > width * 1.05;
  }

  // 스레드 풀 안전하게 종료
  public void shutdownExecutor() throws InterruptedException {
    executor.shutdown();
    if (!executor.awaitTermination(60, TimeUnit.SECONDS)) {
      executor.shutdownNow();
    }
  }

  public static class ProcessedImage {
    private final String url;
    private final String numberWithBlurhash;
    private final int index;

    public ProcessedImage(String url, String numberWithBlurhash, int index) {
      this.url = url;
      this.numberWithBlurhash = numberWithBlurhash;
      this.index = index;
    }

    public String getUrl() {
      return url;
    }

    public String getNumberWithBlurhash() {
      return numberWithBlurhash;
    }

    public int getIndex() {
      return index;
    }
  }
}
