package io.github.sms1875.gamepaper.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;
import java.io.IOException;
import java.net.URL;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@Service
public class WallpaperProcessingService {

  private static final Logger logger = LoggerFactory.getLogger(WallpaperProcessingService.class);

  public List<ProcessedImage> processImages(List<String> urls) {
    AtomicInteger counter = new AtomicInteger(1);
    return urls.stream()
        .filter(this::isPortraitImage)
        .map(url -> new ProcessedImage(url, String.format("%03d", counter.getAndIncrement())))
        .collect(Collectors.toList());
  }

  private boolean isPortraitImage(String imageUrl) {
    try {
      URL url = new URL(imageUrl);
      try (ImageInputStream iis = ImageIO.createImageInputStream(url.openStream())) {
        Iterator<ImageReader> readers = ImageIO.getImageReaders(iis);
        if (!readers.hasNext()) {
          logger.warn("No image reader found for URL: {}", imageUrl);
          return false;
        }

        ImageReader reader = readers.next();
        try {
          reader.setInput(iis);
          int width = reader.getWidth(0);
          int height = reader.getHeight(0);

          return height > (width * 1.05);
        } finally {
          reader.dispose();
        }
      }
    } catch (IOException e) {
      logger.error("Failed to load image from URL: {}", imageUrl, e);
      return false;
    }
  }

  public static class ProcessedImage {
    private final String url;
    private final String number;

    public ProcessedImage(String url, String number) {
      this.url = url;
      this.number = number;
    }

    public String getUrl() {
      return url;
    }

    public String getNumber() {
      return number;
    }
  }
}