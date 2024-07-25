package io.github.sms1875.gamepaper.service;

import java.util.ArrayList;
import java.util.List;

import org.openqa.selenium.WebDriver;

public abstract class PagedGameImageRetrievalService extends AbstractGameImageRetrievalService {
  public PagedGameImageRetrievalService(WebDriver webDriver) {
    super(webDriver);
  }

  @Override
  public List<String> getImageUrls() {
    List<String> imageUrls = new ArrayList<>();
    try {
      navigateToFirstPage();
      do {
        imageUrls.addAll(extractImageUrlsFromPage());
      } while (navigateToNextPage());
    } catch (Exception e) {
      e.printStackTrace();
    }
    return imageUrls;
  }

  protected abstract void navigateToFirstPage();

  protected abstract boolean navigateToNextPage();
}