package io.github.sms1875.gamepaper.service;

import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

@Service("nikke")
public class NikkePagedImageRetrievalService extends AbstractGameImageRetrievalService {

  // 상수 선언
  private static final String BASE_URL = "https://nikke-kr.com/art.html?active_tab=1864";
  private static final int TOTAL_PAGES = 16; // 필요에 따라 조정
  private static final String TAB_TEXT = "모바일 배경화면";
  private static final String PAGE_ICONS_XPATH = "//ul[@class='page-icons']//li[@data-page='%d']";
  private static final String IMAGE_LIST_XPATH = "//div[@class='list w-vertical']//div[@class='item']//img";
  private static final String ART_CONTAINER_CSS = ".art-container";
  private static final long DELAY_BEFORE_NEXT_PAGE_MS = 2000; // 2초 지연
  private int currentPage = 0;

  public NikkePagedImageRetrievalService(WebDriver webDriver) {
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
   * 첫 번째 페이지로 이동하고 필요한 탭을 클릭합니다.
   */
  private void navigateToFirstPage() {
    currentPage = 0;
    webDriver.get(BASE_URL);
    waitForPageLoad();
    clickTab(TAB_TEXT);
    waitForPageLoad(); // 탭 변경 후 콘텐츠 로드를 기다림
  }

  /**
   * 지정된 텍스트를 가진 탭을 클릭합니다.
   *
   * @param tabText 클릭할 탭의 텍스트
   */
  private void clickTab(String tabText) {
    WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofSeconds(30));
    try {
      WebElement tab = wait.until(ExpectedConditions.elementToBeClickable(By.xpath(
          String.format("//div[@class='child-tab-item' and text()='%s']", tabText))));
      ((JavascriptExecutor) webDriver).executeScript("arguments[0].click();", tab);
    } catch (Exception e) {
      handleException(e);
    }
  }

  /**
   * 2초 지연 후 다음 페이지로 이동합니다.
   *
   * @return 다음 페이지가 있으면 true, 없으면 false
   */
  private boolean navigateToNextPageWithDelay() {
    boolean result = navigateToPage(currentPage + 1);
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
   * 지정된 페이지 번호로 이동합니다.
   *
   * @param pageNumber 이동할 페이지 번호
   * @return 성공적으로 이동하면 true, 아니면 false
   */
  private boolean navigateToPage(int pageNumber) {
    if (pageNumber < 0 || pageNumber >= TOTAL_PAGES) {
      return false; // 페이지 번호가 유효 범위를 벗어남
    }

    WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofSeconds(30));
    try {
      WebElement pageIcon = wait.until(ExpectedConditions.elementToBeClickable(By.xpath(
          String.format(PAGE_ICONS_XPATH, pageNumber))));
      ((JavascriptExecutor) webDriver).executeScript("arguments[0].click();", pageIcon);

      waitForImagesToLoad();
      currentPage = pageNumber;
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
    WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofSeconds(30));
    wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector(ART_CONTAINER_CSS)));
  }

  /**
   * 이미지가 로드될 때까지 대기합니다.
   */
  private void waitForImagesToLoad() {
    WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofSeconds(30));
    try {
      wait.until(ExpectedConditions.presenceOfAllElementsLocatedBy(By.xpath(IMAGE_LIST_XPATH)));
    } catch (Exception e) {
      handleException(e);
    }
  }

  /**
   * 현재 페이지에서 이미지 URL을 추출하여 리스트로 반환합니다.
   *
   * @return 이미지 URL 리스트
   */
  @Override
  protected List<String> extractImageUrlsFromPage() {
    List<String> imageUrls = new ArrayList<>();
    WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofSeconds(30));

    try {
      List<WebElement> imageElements = wait.until(ExpectedConditions.presenceOfAllElementsLocatedBy(
          By.xpath(IMAGE_LIST_XPATH)));

      for (WebElement imageElement : imageElements) {
        String imageUrl = imageElement.getAttribute("src");
        if (isValidUrl(imageUrl)) {
          imageUrls.add(imageUrl);
        }
      }
    } catch (Exception e) {
      handleException(e);
    }

    return imageUrls;
  }

  /**
   * 이미지 URL이 유효한지 검사합니다.
   *
   * @param url 검사할 URL
   * @return 유효한 URL이면 true, 그렇지 않으면 false
   */
  private boolean isValidUrl(String url) {
    return url != null && !url.isEmpty();
  }

  /**
   * 예외가 발생했을 때 처리하는 메서드.
   *
   * @param e 발생한 예외
   */
  private void handleException(Exception e) {
    // 로깅 프레임워크 사용 권장
    e.printStackTrace();
  }
}
