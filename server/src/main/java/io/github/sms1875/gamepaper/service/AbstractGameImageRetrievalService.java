package io.github.sms1875.gamepaper.service;

import org.openqa.selenium.WebDriver;

import java.time.Duration;
import java.util.List;
import java.util.concurrent.CompletableFuture;

public abstract class AbstractGameImageRetrievalService {
  protected final WebDriver webDriver;
  protected static final Duration TIMEOUT = Duration.ofSeconds(10);

  public AbstractGameImageRetrievalService(WebDriver webDriver) {
    this.webDriver = webDriver;
  }

  public abstract List<String> getImageUrls();

  public CompletableFuture<List<String>> getImageUrlsAsync() {
    return CompletableFuture.supplyAsync(this::getImageUrls);
  }

  protected abstract List<String> extractImageUrlsFromPage();

  /**
   * 예외가 발생했을 때 처리하는 메서드.
   *
   * @param e 발생한 예외
   */
  public void handleException(Exception e) {
    // 로그를 남기고 예외를 처리할 수 있습니다. 예를 들어:
    e.printStackTrace();
    // 로깅 프레임워크를 사용하는 경우, e.printStackTrace() 대신 로그를 기록하세요.
  }

  /**
   * 이미지 URL이 유효한지 검사합니다.
   *
   * @param url 검사할 URL
   * @return 유효한 URL이면 true, 그렇지 않으면 false
   */
  public boolean isValidUrl(String url) {
    return url != null && !url.isEmpty();
  }
}