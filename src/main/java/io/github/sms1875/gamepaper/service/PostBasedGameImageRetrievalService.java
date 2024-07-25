package io.github.sms1875.gamepaper.service;

import java.util.ArrayList;
import java.util.List;

import org.openqa.selenium.WebDriver;

public abstract class PostBasedGameImageRetrievalService extends AbstractGameImageRetrievalService {
  public PostBasedGameImageRetrievalService(WebDriver webDriver) {
    super(webDriver);
  }

  @Override
  public List<String> getImageUrls() {
    List<String> imageUrls = new ArrayList<>();
    try {
      List<String> postUrls = getPostUrls();
      for (String postUrl : postUrls) {
        navigateToPost(postUrl);
        imageUrls.addAll(extractImageUrlsFromPost());
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return imageUrls;
  }

  protected abstract List<String> getPostUrls();

  protected abstract void navigateToPost(String postUrl);

  protected abstract List<String> extractImageUrlsFromPost();
}