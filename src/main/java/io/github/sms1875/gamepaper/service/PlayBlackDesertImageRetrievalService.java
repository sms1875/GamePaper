package io.github.sms1875.gamepaper.service;

import java.util.ArrayList;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.stereotype.Service;

@Service("playblackdesert")
public class PlayBlackDesertImageRetrievalService extends PagedGameImageRetrievalService {
  private static final String BASE_URL = "https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/";

  public PlayBlackDesertImageRetrievalService(WebDriver webDriver) {
    super(webDriver);
  }

  @Override
  protected void navigateToFirstPage() {
    webDriver.get(BASE_URL);
  }

  @Override
  protected boolean navigateToNextPage() {
    try {
      WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT);
      WebElement nextPageElement = wait
          .until(ExpectedConditions.elementToBeClickable(By.cssSelector("#paging .btn_arrow.next")));
      if (nextPageElement.isDisplayed()) {
        nextPageElement.click();
        return true;
      }
    } catch (Exception e) {
      return false;
    }
    return false;
  }

  @Override
  protected List<String> extractImageUrlsFromPage() {
    List<String> pageImageUrls = new ArrayList<>();
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT);
    wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("wallpaper_list")));
    List<WebElement> wallpaperElements = webDriver.findElements(By.cssSelector("#wallpaper_list li a"));

    for (WebElement element : wallpaperElements) {
      String imgUrl = element.getAttribute("attr-img_m");
      if (imgUrl != null && imgUrl.startsWith("http")) {
        pageImageUrls.add(imgUrl);
      }
    }
    return pageImageUrls;
  }

  @Override
  public String getGameName() {
    return "Black Desert";
  }
}