package io.github.sms1875.gamepaper.service;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service("monsterhunter")
public class MonsterHunterImageRetrievalService extends AbstractGameImageRetrievalService {
  private static final String BASE_URL = "https://www.monsterhunter.com/mha/en/wallpaper_gift/";

  public MonsterHunterImageRetrievalService(WebDriver webDriver) {
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

  private void navigateToPage() {
    webDriver.get(BASE_URL);
  }

  @Override
  protected List<String> extractImageUrlsFromPage() {
    List<String> imageUrls = new ArrayList<>();
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT);
    wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//*[@id='dlArea01']")));

    List<WebElement> imageLinks = webDriver.findElements(By.xpath("//*[@id='dlArea01']/div/ul/li/p/a"));

    for (WebElement link : imageLinks) {
      String imgUrl = link.getAttribute("href");
      if (imgUrl != null && imgUrl.startsWith("http")) {
        imageUrls.add(imgUrl);
      }
    }

    return imageUrls;
  }
}