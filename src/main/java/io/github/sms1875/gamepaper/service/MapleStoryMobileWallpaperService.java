package io.github.sms1875.gamepaper.service;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

@Service("maplestory")
public class MapleStoryMobileWallpaperService extends AbstractGameImageRetrievalService {
  private static final String BASE_URL = "https://m.maplestory.nexon.com/Media/MobileWallPaper";
  private int currentPage = 1;

  public MapleStoryMobileWallpaperService(WebDriver webDriver) {
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

  private void navigateToFirstPage() {
    currentPage = 1;
    webDriver.get(BASE_URL);
  }

  private boolean navigateToNextPage() {
    WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofSeconds(10));
    try {
      WebElement nextButton = wait
          .until(ExpectedConditions.elementToBeClickable(By.cssSelector(".page_numb .cm_next")));
      if (nextButton.getAttribute("class").contains("nopage")) {
        return false;
      }
      currentPage++;
      String nextPageUrl = BASE_URL + "?page=" + currentPage;
      webDriver.get(nextPageUrl);
      wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector(".artwork_board_list")));
      return true;
    } catch (Exception e) {
      return false;
    }
  }

  @Override
  protected List<String> extractImageUrlsFromPage() {
    List<String> imageUrls = new ArrayList<>();
    WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofSeconds(10));

    List<WebElement> thumbnails = wait.until(ExpectedConditions.presenceOfAllElementsLocatedBy(
        By.cssSelector(".artwork_board_list .artwork-list-group img")));

    for (WebElement thumbnail : thumbnails) {
      String imageUrl = thumbnail.getAttribute("src");
      if (imageUrl != null && imageUrl.startsWith("http")) {
        imageUrls.add(imageUrl);
      }
    }

    return imageUrls;
  }
}