package io.github.sms1875.gamepaper.service;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.stereotype.Service;

@Service("mabinogi")
public class MabinogiImageRetrievalService extends AbstractGameImageRetrievalService {

  // 상수 선언
  private static final String BASE_URL = "https://mabinogi.nexon.com/page/pds/gallery_wallpaper.asp";
  private static final String CONTENT_DIV_XPATH = "//*[@id='div_contents']/div[2]/div[2]";
  private static final String LIST_ITEM_XPATH = CONTENT_DIV_XPATH + "/ul/li";
  private static final String VIEW_WALL2_FUNCTION = "javascript:viewWall2";
  private static final String APPLE_IOS_TEXT = "Apple iOS";
  private static final String VIEW_WALL2_PREFIX = "javascript:viewWall2('";
  private static final String VIEW_WALL2_SUFFIX = "', ";

  public MabinogiImageRetrievalService(WebDriver webDriver) {
    super(webDriver);
  }

  @Override
  public List<String> getImageUrls() {
    List<String> imageUrls = new ArrayList<>();
    try {
      navigateToPage();
      imageUrls.addAll(extractImageUrlsFromPage());
    } catch (Exception e) {
      // 에러를 로깅 프레임워크로 처리할 것을 권장
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

    wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath(CONTENT_DIV_XPATH)));
    List<WebElement> liElements = webDriver.findElements(By.xpath(LIST_ITEM_XPATH));

    for (WebElement liElement : liElements) {
      List<WebElement> aElements = liElement
          .findElements(By.xpath(".//a[contains(@href, '" + VIEW_WALL2_FUNCTION + "')]"));
      for (WebElement aElement : aElements) {
        WebElement spanElement = aElement.findElement(By.xpath(".//span"));
        String spanText = spanElement.getText();

        if (spanText.contains(APPLE_IOS_TEXT)) {
          String href = aElement.getAttribute("href");
          String imgUrl = extractImageUrlFromHref(href);

          if (imgUrl != null && imgUrl.startsWith("http")) {
            imageUrls.add(imgUrl);
          }
        }
      }
    }
    return imageUrls;
  }

  private String extractImageUrlFromHref(String href) {
    if (href == null || !href.startsWith(VIEW_WALL2_FUNCTION)) {
      return null;
    }

    int startIndex = href.indexOf(VIEW_WALL2_PREFIX) + VIEW_WALL2_PREFIX.length();
    int endIndex = href.indexOf(VIEW_WALL2_SUFFIX, startIndex);

    if (startIndex > -1 && endIndex > -1) {
      String encodedUrl = href.substring(startIndex, endIndex);
      try {
        return URLDecoder.decode(encodedUrl, StandardCharsets.UTF_8.name());
      } catch (Exception e) {
        // 로깅 프레임워크 사용 권장
        e.printStackTrace();
      }
    }
    return null;
  }
}
