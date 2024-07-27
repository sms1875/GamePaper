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

@Service("finalfantasy")
public class FinalFantasyImageRetrievalService extends AbstractGameImageRetrievalService {
  private static final String BASE_URL = "https://na.finalfantasyxiv.com/lodestone/special/fankit/smartphone_wallpaper/";

  public FinalFantasyImageRetrievalService(WebDriver webDriver) {
    super(webDriver);
  }

  @Override
  public List<String> getImageUrls() {
    List<String> imageUrls = new ArrayList<>();
    try {
      String[] expansions = { "7_0", "6_0", "5_0", "4_0", "3_0", "2_0" };
      for (String expansion : expansions) {
        navigateToPage(expansion);
        imageUrls.addAll(extractImageUrlsFromPage());
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return imageUrls;
  }

  private void navigateToPage(String expansion) {
    webDriver.get(BASE_URL + expansion + "/#nav_fankit");
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT);
    wait.until(ExpectedConditions.presenceOfElementLocated(By.xpath("//*[@id=\"pc_wallpaper\"]/div/div/ul[1]")));
  }

  @Override
  protected List<String> extractImageUrlsFromPage() {
    List<String> imageUrls = new ArrayList<>();
    WebDriverWait wait = new WebDriverWait(webDriver, TIMEOUT);
    wait.until(ExpectedConditions.presenceOfElementLocated(By.xpath("//*[@id=\"pc_wallpaper\"]/div/div/ul[2]")));
    List<WebElement> wallpaperElements = webDriver
        .findElements(By.xpath("//*[@id=\"pc_wallpaper\"]/div/div/ul[2]/li/p/a[3]"));

    for (WebElement element : wallpaperElements) {
      String imgUrl = element.getAttribute("href");
      if (imgUrl != null && imgUrl.startsWith("http")) {
        imageUrls.add(imgUrl);
      }
    }
    return imageUrls;
  }

  @Override
  public String getGameName() {
    return "Final Fantasy XIV";
  }
}
