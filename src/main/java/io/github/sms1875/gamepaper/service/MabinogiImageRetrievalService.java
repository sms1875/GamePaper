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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("mabinogi")
public class MabinogiImageRetrievalService extends SinglePageGameImageRetrievalService {
  private static final String BASE_URL = "https://mabinogi.nexon.com/page/pds/gallery_wallpaper.asp";

  @Autowired
  public MabinogiImageRetrievalService(WebDriver webDriver) {
    super(webDriver);
  }

  @Override
  protected void navigateToPage() {
    webDriver.get(BASE_URL);
  }

  @Override
  protected List<String> extractImageUrlsFromPage() {
    List<String> imageUrls = new ArrayList<>();
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT);
    wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//*[@id=\"div_contents\"]/div[2]/div[2]")));
    List<WebElement> liElements = webDriver.findElements(By.xpath("//*[@id=\"div_contents\"]/div[2]/div[2]/ul/li"));

    for (WebElement liElement : liElements) {
      List<WebElement> aElements = liElement.findElements(By.xpath(".//a[contains(@href, 'javascript:viewWall2')]"));
      for (WebElement aElement : aElements) {
        WebElement spanElement = aElement.findElement(By.xpath(".//span"));
        String spanText = spanElement.getText();
        if (spanText.contains("Apple iOS")) {
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
    if (href == null || !href.startsWith("javascript:viewWall2")) {
      return null;
    }

    String prefix = "javascript:viewWall2('";
    String suffix = "', ";
    int startIndex = href.indexOf(prefix) + prefix.length();
    int endIndex = href.indexOf(suffix, startIndex);

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

  @Override
  public String getGameName() {
    return "Mabinogi";
  }
}