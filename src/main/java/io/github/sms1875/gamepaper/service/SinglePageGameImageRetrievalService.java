package io.github.sms1875.gamepaper.service;

import java.util.ArrayList;
import java.util.List;

import org.openqa.selenium.WebDriver;

public abstract class SinglePageGameImageRetrievalService extends AbstractGameImageRetrievalService {
  public SinglePageGameImageRetrievalService(WebDriver webDriver) {
    super(webDriver);
  }

  @Override
  public List<String> getImageUrls() {
    List<String> imageUrls = new ArrayList<>();
    try {
      navigateToPage();
      imageUrls.addAll(extractImageUrlsFromPage());
    } catch (Exception e) {
      e.printStackTrace();
    }
    return imageUrls;
  }

  protected abstract void navigateToPage();
}