package io.github.sms1875.gamepaper.service;

import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ImageRetrievalServiceImpl implements ImageRetrievalService {

  @Autowired
  private WebDriver webDriver;

  @Override
  public List<String> getAllImageUrlsFromAllPages() {
    List<String> imageUrls = new ArrayList<>();
    String baseUrl = "https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/";
    try {
      webDriver.get(baseUrl);
      Thread.sleep(2000); // Wait for the page to load

      boolean hasNextPage = true;
      while (hasNextPage) {
        imageUrls.addAll(getImagesFromCurrentPage());
        hasNextPage = navigateToNextPage();
        if (hasNextPage) {
          Thread.sleep(2000); // Wait for the next page to load
        }
      }
    } catch (Exception e) {
      e.printStackTrace(); // Use logging in production code
    }
    return imageUrls;
  }

  private List<String> getImagesFromCurrentPage() {
    List<String> imageUrls = new ArrayList<>();
    List<WebElement> wallpaperElements = webDriver.findElements(By.xpath("//*[@id=\"wallpaper_list\"]/li/a"));

    for (WebElement wallpaperElement : wallpaperElements) {
      String imgUrl = wallpaperElement.getAttribute("attr-img_m");
      if (imgUrl != null && imgUrl.startsWith("http")) {
        imageUrls.add(imgUrl);
      }
    }
    return imageUrls;
  }

  private boolean navigateToNextPage() {
    try {
      WebElement nextPageElement = webDriver.findElement(By.cssSelector("#paging .btn_arrow.next"));
      if (nextPageElement != null && nextPageElement.isDisplayed()) {
        String nextPageUrl = nextPageElement.getAttribute("href");
        webDriver.get(nextPageUrl);
        return true;
      }
    } catch (NoSuchElementException e) {
      // No next page found or other navigation issue
    }
    return false;
  }
}
