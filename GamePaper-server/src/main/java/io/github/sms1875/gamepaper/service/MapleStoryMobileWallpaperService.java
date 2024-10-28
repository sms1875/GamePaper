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

  // 상수 선언
  private static final String BASE_URL = "https://m.maplestory.nexon.com/Media/MobileWallPaper";
  private static final String NEXT_BUTTON_SELECTOR = ".page_numb .cm_next";
  private static final String ARTWORK_LIST_SELECTOR = ".artwork_board_list .artwork-list-group img";
  private static final String ARTWORK_BOARD_SELECTOR = ".artwork_board_list";
  private static final Duration TIMEOUT_DURATION = Duration.ofSeconds(10);
  private static final long DELAY_BEFORE_NEXT_PAGE_MS = 2000; // 2초 지연

  private int currentPage = 1;

  public MapleStoryMobileWallpaperService(WebDriver webDriver) {
    super(webDriver);
  }

  /**
   * 웹사이트에서 월페이퍼 이미지 URL 목록을 가져옵니다.
   *
   * @return 이미지 URL 리스트
   */
  @Override
  public List<String> getImageUrls() {
    List<String> imageUrls = new ArrayList<>();
    try {
      navigateToFirstPage();
      do {
        imageUrls.addAll(extractImageUrlsFromPage());
      } while (navigateToNextPageWithDelay());
    } catch (Exception e) {
      handleException(e);
    }
    return imageUrls;
  }

  /**
   * 첫 번째 페이지로 이동합니다.
   */
  private void navigateToFirstPage() {
    currentPage = 1;
    webDriver.get(BASE_URL);
    waitForPageLoad();
  }

  /**
   * 2초 지연 후 다음 페이지로 이동합니다.
   *
   * @return 다음 페이지가 있으면 true, 없으면 false
   */
  private boolean navigateToNextPageWithDelay() {
    boolean result = navigateToNextPage();
    if (result) {
      try {
        Thread.sleep(DELAY_BEFORE_NEXT_PAGE_MS); // 2초 지연
      } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
      }
    }
    return result;
  }

  /**
   * 다음 페이지로 이동합니다.
   *
   * @return 성공적으로 이동하면 true, 아니면 false
   */
  private boolean navigateToNextPage() {
    try {
      WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT_DURATION);
      WebElement nextButton = wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector(NEXT_BUTTON_SELECTOR)));

      if (nextButton.getAttribute("class").contains("nopage")) {
        return false; // 다음 페이지가 없음
      }

      currentPage++;
      String nextPageUrl = BASE_URL + "?page=" + currentPage;
      webDriver.get(nextPageUrl);
      waitForPageLoad();
      return true;
    } catch (Exception e) {
      handleException(e);
      return false;
    }
  }

  /**
   * 페이지가 완전히 로드될 때까지 대기합니다.
   */
  private void waitForPageLoad() {
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT_DURATION);
    wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector(ARTWORK_BOARD_SELECTOR)));
  }

  /**
   * 현재 페이지에서 이미지 URL을 추출하여 리스트로 반환합니다.
   *
   * @return 이미지 URL 리스트
   */
  @Override
  protected List<String> extractImageUrlsFromPage() {
    List<String> imageUrls = new ArrayList<>();
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT_DURATION);

    try {
      List<WebElement> thumbnails = wait.until(ExpectedConditions.presenceOfAllElementsLocatedBy(
          By.cssSelector(ARTWORK_LIST_SELECTOR)));

      for (WebElement thumbnail : thumbnails) {
        String imageUrl = thumbnail.getAttribute("src");
        if (isValidUrl(imageUrl)) {
          imageUrls.add(imageUrl);
        }
      }
    } catch (Exception e) {
      handleException(e);
    }

    return imageUrls;
  }
}
