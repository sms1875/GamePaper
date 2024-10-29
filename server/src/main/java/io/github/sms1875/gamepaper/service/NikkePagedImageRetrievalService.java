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
  private static final String TAB_TEXT = "모바일 배경화면 1080*1920";
  private static final String PAGE_ICONS_XPATH_TEMPLATE = "//ul[@class='page-icons']//li[@data-page='%d']";
  private static final String IMAGE_LIST_XPATH = "//div[@class='list w-vertical']//div[@class='item']//img";
  private static final String PAGE_ICONS_XPATH = "//*[@id='wrapper_id']/div[5]/div/ul";
  private static final String ART_CONTAINER_CSS = ".art-container";
  private static final long DELAY_BEFORE_NEXT_PAGE_MS = 2000; // 페이지 이동 전 지연 시간 (밀리초 단위)
  private static final Duration TIMEOUT = Duration.ofSeconds(30); // 기본 타임아웃 시간

  private int currentPage = 0; // 현재 페이지 번호
  private int totalPages = 0; // 총 페이지 수

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
   * 첫 번째 페이지로 이동하고, 모바일 배경화면 탭을 클릭한 뒤 목록이 로드될 때까지 대기한 후 총 페이지 수를 가져옵니다.
   */
  private void navigateToFirstPage() {
    currentPage = 0;
    webDriver.get(BASE_URL);
    waitForPageLoad();
    clickTab(TAB_TEXT);
    waitForVerticalListDisplay();
    totalPages = getTotalPages(); // 총 페이지 수를 가져옴
  }

  /**
   * 주어진 텍스트를 가진 탭을 클릭합니다.
   *
   * @param tabText 클릭할 탭의 텍스트
   */
  private void clickTab(String tabText) {
    String tabXpath = String.format("//div[@class='child-tab-item' and text()='%s']", tabText); // 탭 Xpath 템플릿
    clickElement(By.xpath(tabXpath));
  }

  /**
   * "list w-vertical" 클래스의 요소가 "display: block;"이 될 때까지 대기합니다.
   */
  private void waitForVerticalListDisplay() {
    waitForElementToBeDisplayed(By.cssSelector(".list.w-vertical"), "display: block;");
  }

  /**
   * 페이지의 특정 요소가 클릭 가능해질 때까지 대기한 후 클릭합니다.
   *
   * @param by 클릭할 요소의 By 객체
   */
  private void clickElement(By by) {
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT);
    try {
      WebElement element = wait.until(ExpectedConditions.elementToBeClickable(by));
      ((JavascriptExecutor) webDriver).executeScript("arguments[0].click();", element);
    } catch (Exception e) {
      handleException(e);
    }
  }

  /**
   * 지정된 스타일 속성값이 적용될 때까지 대기합니다.
   *
   * @param by         대기할 요소의 By 객체
   * @param styleValue 대기할 스타일 속성값
   */
  private void waitForElementToBeDisplayed(By by, String styleValue) {
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT);
    try {
      wait.until(ExpectedConditions.attributeToBe(by, "style", styleValue));
    } catch (Exception e) {
      handleException(e);
    }
  }

  /**
   * 총 페이지 수를 가져오는 메서드.
   *
   * @return 총 페이지 수
   */
  private int getTotalPages() {
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT);
    try {
      WebElement pageIcons = wait.until(ExpectedConditions.presenceOfElementLocated(By.xpath(PAGE_ICONS_XPATH)));
      List<WebElement> pageItems = pageIcons.findElements(By.tagName("li"));
      return pageItems.size(); // 총 페이지 수 반환
    } catch (Exception e) {
      handleException(e);
      return 0; // 예외 발생 시 0 반환
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
        Thread.sleep(DELAY_BEFORE_NEXT_PAGE_MS); // 페이지 이동 전 2초 지연
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
    if (pageNumber < 0 || pageNumber >= totalPages) {
      return false; // 페이지 번호가 유효 범위를 벗어남
    }

    String pageIconXpath = String.format(PAGE_ICONS_XPATH_TEMPLATE, pageNumber); // 페이지 아이콘 Xpath 템플릿

    clickElement(By.xpath(pageIconXpath));

    currentPage = pageNumber;
    waitForImagesToLoad();
    waitForPageLoad();

    return true;
  }

  /**
   * 페이지가 완전히 로드될 때까지 대기합니다.
   */
  private void waitForPageLoad() {
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT);
    wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector(ART_CONTAINER_CSS)));
  }

  /**
   * 이미지가 로드될 때까지 대기합니다.
   */
  private void waitForImagesToLoad() {
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT);
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
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT);

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
}
