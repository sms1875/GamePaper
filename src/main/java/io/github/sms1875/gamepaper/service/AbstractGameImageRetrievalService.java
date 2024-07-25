package io.github.sms1875.gamepaper.service;

import org.openqa.selenium.WebDriver;
import java.time.Duration;
import java.util.List;
import java.util.concurrent.CompletableFuture;

public abstract class AbstractGameImageRetrievalService implements GameImageRetrievalService {
  protected final WebDriver webDriver;
  protected static final Duration TIMEOUT = Duration.ofSeconds(10);

  public AbstractGameImageRetrievalService(WebDriver webDriver) {
    this.webDriver = webDriver;
  }

  @Override
  public CompletableFuture<List<String>> getImageUrlsAsync() {
    return CompletableFuture.supplyAsync(this::getImageUrls);
  }

  protected abstract List<String> extractImageUrlsFromPage();
}
