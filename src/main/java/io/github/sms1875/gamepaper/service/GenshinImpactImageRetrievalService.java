package io.github.sms1875.gamepaper.service;

import org.openqa.selenium.*;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

@Service("genshinimpact")
public class GenshinImpactImageRetrievalService extends SinglePageGameImageRetrievalService {
  private static final String BASE_URL = "https://www.hoyolab.com/creatorCollection/526679";
  private static final Duration TIMEOUT = Duration.ofSeconds(20);
  private static final String BASE64_IMAGE_PREFIX = "data:image/png;base64";

  public GenshinImpactImageRetrievalService(WebDriver webDriver) {
    super(webDriver);
  }

  @Override
  protected void navigateToPage() {
    webDriver.get(BASE_URL);
    handleInterestSelector();
  }

  private void handleInterestSelector() {
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT);
    try {
      WebElement skipButton = wait.until(ExpectedConditions.elementToBeClickable(
          By.xpath("//button[contains(@class, 'normal__quaternary') and .//span[text()='건너뛰기']]")));
      skipButton.click();
      wait.until(ExpectedConditions.stalenessOf(skipButton));
      wait.until(ExpectedConditions.presenceOfElementLocated(By.xpath(
          "//*[@id=\"__layout\"]/div/div[2]/div/div[1]/div/div/div[3]/div/div[1]/div[1]/div[2]/a/div[2]/div[1]/img")));
    } catch (Exception e) {
      // 관심사 선택 대화상자가 나타나지 않으면 아무것도 하지 않습니다.
    }
  }

  @Override
  protected List<String> extractImageUrlsFromPage() {
    List<String> imageUrls = new ArrayList<>();
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT);
    JavascriptExecutor jsExecutor = (JavascriptExecutor) webDriver;

    // 페이지 끝까지 스크롤하고 "클릭하여 더 보기" 버튼을 클릭
    while (true) {
      try {
        // 페이지 끝까지 스크롤
        jsExecutor.executeScript("window.scrollTo(0, document.body.scrollHeight);");
        Thread.sleep(2000); // 스크롤 후 대기

        // "클릭하여 더 보기" 버튼이 있으면 클릭
        List<WebElement> loadMoreButtons = webDriver
            .findElements(By.xpath("//div[@class='mhy-article-list__footer']//button[.//span[text()='클릭하여 더 보기']]"));
        if (!loadMoreButtons.isEmpty()) {
          loadMoreButtons.get(0).click();
          Thread.sleep(2000); // 버튼 클릭 후 대기
        } else {
          // 스크롤의 끝에 도달했는지 확인
          List<WebElement> noMoreElements = webDriver.findElements(
              By.xpath("//div[@class='mhy-article-list__footer']//div[contains(@class, 'mhy-loadmore--complete')]"));
          if (!noMoreElements.isEmpty()) {
            break; // 더 이상 로드할 게시글이 없음
          }
        }
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }

    while (true) {
      try {
        List<WebElement> postElements = wait.until(ExpectedConditions.presenceOfAllElementsLocatedBy(
            By.xpath("//*[@id=\"__layout\"]/div/div[2]/div/div[1]/div/div/div[3]/div/div[1]/div")));

        for (WebElement post : postElements) {
          List<WebElement> thumbnailElements = post.findElements(By.xpath(".//a/div[2]/div[1]/img"));

          for (WebElement thumbnail : thumbnailElements) {
            // 이미지 위치로 스크롤
            jsExecutor.executeScript("arguments[0].scrollIntoView({block: 'center'});", thumbnail);
            try {
              Thread.sleep(500);
            } catch (InterruptedException e) {
              // TODO Auto-generated catch block
              e.printStackTrace();
            } // 스크롤 후 대기

            wait.until(ExpectedConditions.elementToBeClickable(thumbnail)).click();

            // 새로운 XPath로 이미지 뷰어 컨테이너를 찾습니다
            WebElement viewerContainer = wait.until(ExpectedConditions.visibilityOfElementLocated(
                By.xpath("//div[contains(@class, 'hoyolab-image-preview-container')]")));

            // 이미지 뷰어 내의 이미지가 로드될 때까지 대기
            List<WebElement> viewerImages = wait.until(ExpectedConditions.presenceOfAllElementsLocatedBy(
                By.xpath("//div[contains(@class, 'hoyolab-image-preview-container')]//ul/li/img")));

            for (WebElement viewerImage : viewerImages) {
              // data:image/png;base64,로 시작하는 기본 이미지가 로드되지 않을 때까지 대기
              wait.until(
                  ExpectedConditions.not(ExpectedConditions.attributeToBe(viewerImage, "src", BASE64_IMAGE_PREFIX)));

              String imageUrl = viewerImage.getAttribute("src");
              if (imageUrl != null && !imageUrl.startsWith(BASE64_IMAGE_PREFIX)) {
                imageUrls.add(imageUrl);
              }
            }

            // 뷰어 닫기
            WebElement closeButton = wait.until(ExpectedConditions.elementToBeClickable(
                By.xpath(
                    "//div[contains(@class, 'hoyolab-image-preview-container')]//div[contains(@class, 'viewer-close')]")));
            closeButton.click();

            // 뷰어가 닫힐 때까지 대기
            wait.until(ExpectedConditions.invisibilityOf(viewerContainer));

            // 딜레이 추가
            try {
              Thread.sleep(1000); // 1초 대기
            } catch (InterruptedException e) {
              e.printStackTrace();
            }
          }
        }

        // 모든 이미지를 처리했으면 루프를 종료합니다.
        break;
      } catch (org.openqa.selenium.StaleElementReferenceException e) {
        // 요소가 오래되었다면 페이지를 새로고침하고 다시 시도합니다.
        webDriver.navigate().refresh();
        wait.until(ExpectedConditions.presenceOfElementLocated(
            By.xpath(
                "//*[@id=\"__layout\"]/div/div[2]/div/div[1]/div/div/div[3]/div/div[1]/div[1]/div[2]/a/div[2]/div[1]/img")));
      } catch (org.openqa.selenium.TimeoutException e) {
        System.out.println("시간 초과 발생: " + e.getMessage());
        break;
      }
    }

    return imageUrls;
  }

  @Override
  public String getGameName() {
    return "Genshin Impact";
  }
}
