package io.github.sms1875.gamepaper.service;

import org.openqa.selenium.*;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

@Service("genshinimpact")
public class GenshinImpactImageRetrievalService extends AbstractGameImageRetrievalService {

  // 상수 선언
  private static final String BASE_URL = "https://www.hoyolab.com/creatorCollection/526679";
  private static final Duration TIMEOUT = Duration.ofSeconds(20);
  private static final String INTEREST_SELECTOR_XPATH = "//button[contains(@class, 'normal__quaternary') and .//span[text()='건너뛰기']]";
  private static final String ARTICLE_IMAGE_XPATH = "//*[@id=\"__layout\"]/div/div[2]/div/div[1]/div/div/div[3]/div/div[1]/div[1]/div[2]/a/div[2]/div[1]/img";
  private static final String LOAD_MORE_BUTTON_XPATH = "//div[@class='mhy-article-list__footer']//button[.//span[text()='클릭하여 더 보기']]";
  private static final String LOAD_MORE_COMPLETE_XPATH = "//div[@class='mhy-article-list__footer']//div[contains(@class, 'mhy-loadmore--complete')]";
  private static final String POST_LIST_XPATH = "//*[@id=\"__layout\"]/div/div[2]/div/div[1]/div/div/div[3]/div/div[1]/div";
  private static final String THUMBNAIL_XPATH = ".//a/div[2]/div[1]/img";
  private static final String VIEWER_CONTAINER_XPATH = "//div[contains(@class, 'hoyolab-image-preview-container')]";
  private static final String VIEWER_IMAGE_XPATH = "/html/body/div[contains(@class, 'hyl-uniq-container')]/img";
  private static final String VIEWER_CLOSE_BUTTON_XPATH = "//div[contains(@class, 'hoyolab-image-preview-container')]//div[contains(@class, 'viewer-close')]";
  private static final long SCROLL_DELAY_MS = 2000;
  private static final long IMAGE_LOAD_DELAY_MS = 500;

  public GenshinImpactImageRetrievalService(WebDriver webDriver) {
    super(webDriver);
  }

  /**
   * 페이지에서 이미지 URL 목록을 가져옵니다.
   *
   * @return 이미지 URL 리스트
   */
  @Override
  public List<String> getImageUrls() {
    List<String> imageUrls = new ArrayList<>();
    try {
      navigateToPage();
      imageUrls.addAll(extractImageUrlsFromPage());
    } catch (Exception e) {
      handleException(e);
    }
    return imageUrls;
  }

  /**
   * 기본 URL로 이동하여 페이지를 로드하고, 관심사 선택자를 처리합니다.
   */
  private void navigateToPage() {
    webDriver.get(BASE_URL);
    handleInterestSelector();
  }

  /**
   * 관심사 선택자를 처리하고 건너뜁니다.
   */
  private void handleInterestSelector() {
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT);
    try {
      WebElement skipButton = wait.until(ExpectedConditions.elementToBeClickable(By.xpath(INTEREST_SELECTOR_XPATH)));
      skipButton.click();
      wait.until(ExpectedConditions.stalenessOf(skipButton));
      wait.until(ExpectedConditions.presenceOfElementLocated(By.xpath(ARTICLE_IMAGE_XPATH)));
    } catch (Exception e) {
      // 관심사 선택 대화상자가 나타나지 않으면 아무것도 하지 않습니다.
    }
  }

  /**
   * 페이지에서 이미지를 스크롤하며 로드하고 추출합니다.
   *
   * @return 이미지 URL 리스트
   */
  @Override
  protected List<String> extractImageUrlsFromPage() {
    List<String> imageUrls = new ArrayList<>();
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT);
    JavascriptExecutor jsExecutor = (JavascriptExecutor) webDriver;

    // 모든 게시글을 로드합니다.
    scrollAndLoadMorePosts(jsExecutor);

    // 게시글 목록에서 이미지를 추출합니다.
    extractImagesFromPosts(wait, jsExecutor, imageUrls);

    return imageUrls;
  }

  /**
   * 페이지를 스크롤하여 더 많은 게시글을 로드합니다.
   *
   * @param jsExecutor 자바스크립트 실행기
   */
  private void scrollAndLoadMorePosts(JavascriptExecutor jsExecutor) {
    while (true) {
      try {
        // 페이지 끝까지 스크롤
        jsExecutor.executeScript("window.scrollTo(0, document.body.scrollHeight);");
        Thread.sleep(SCROLL_DELAY_MS); // 스크롤 후 대기

        // "클릭하여 더 보기" 버튼이 있으면 클릭
        List<WebElement> loadMoreButtons = webDriver.findElements(By.xpath(LOAD_MORE_BUTTON_XPATH));
        if (!loadMoreButtons.isEmpty()) {
          loadMoreButtons.get(0).click();
          Thread.sleep(SCROLL_DELAY_MS); // 버튼 클릭 후 대기
        } else {
          // 스크롤의 끝에 도달했는지 확인
          List<WebElement> noMoreElements = webDriver.findElements(By.xpath(LOAD_MORE_COMPLETE_XPATH));
          if (!noMoreElements.isEmpty()) {
            break; // 더 이상 로드할 게시글이 없음
          }
        }
      } catch (InterruptedException e) {
        handleException(e);
      }
    }
  }

  /**
   * 게시글 목록에서 이미지를 추출합니다.
   *
   * @param wait       WebDriverWait 객체
   * @param jsExecutor 자바스크립트 실행기
   * @param imageUrls  이미지 URL 리스트
   */
  private void extractImagesFromPosts(WebDriverWait wait, JavascriptExecutor jsExecutor, List<String> imageUrls) {
    while (true) {
      try {
        List<WebElement> postElements = wait
            .until(ExpectedConditions.presenceOfAllElementsLocatedBy(By.xpath(POST_LIST_XPATH)));

        for (WebElement post : postElements) {
          List<WebElement> thumbnailElements = post.findElements(By.xpath(THUMBNAIL_XPATH));

          for (WebElement thumbnail : thumbnailElements) {
            // 이미지 위치로 스크롤
            jsExecutor.executeScript("arguments[0].scrollIntoView({block: 'center'});", thumbnail);
            Thread.sleep(IMAGE_LOAD_DELAY_MS); // 스크롤 후 대기

            wait.until(ExpectedConditions.elementToBeClickable(thumbnail)).click();

            // 이미지 뷰어가 나타날 때까지 대기
            WebElement viewerContainer = wait
                .until(ExpectedConditions.visibilityOfElementLocated(By.xpath(VIEWER_CONTAINER_XPATH)));

            // 이미지 뷰어에서 이미지 URL 추출
            extractImageFromViewer(wait, imageUrls);

            // 뷰어 닫기
            closeViewer(wait, viewerContainer);
          }
        }

        // 모든 이미지를 처리했으면 루프를 종료합니다.
        break;
      } catch (Exception e) {
        handleException(e);
      }
    }
  }

  /**
   * 이미지 뷰어에서 이미지 URL을 추출합니다.
   *
   * @param wait      WebDriverWait 객체
   * @param imageUrls 이미지 URL 리스트
   */
  private void extractImageFromViewer(WebDriverWait wait, List<String> imageUrls) {
    List<WebElement> viewerImages = wait
        .until(ExpectedConditions.presenceOfAllElementsLocatedBy(By.xpath(VIEWER_IMAGE_XPATH)));

    for (WebElement viewerImage : viewerImages) {
      String imageUrl = viewerImage.getAttribute("src");
      if (isValidUrl(imageUrl)) {
        imageUrls.add(imageUrl);
      }
    }
  }

  /**
   * 이미지 뷰어를 닫습니다.
   *
   * @param wait            WebDriverWait 객체
   * @param viewerContainer 뷰어 컨테이너 요소
   */
  private void closeViewer(WebDriverWait wait, WebElement viewerContainer) {
    WebElement closeButton = wait.until(ExpectedConditions.elementToBeClickable(By.xpath(VIEWER_CLOSE_BUTTON_XPATH)));
    closeButton.click();
    wait.until(ExpectedConditions.invisibilityOf(viewerContainer));
  }
}
