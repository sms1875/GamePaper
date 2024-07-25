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
public class NikkePagedImageRetrievalService extends PagedGameImageRetrievalService {
  private static final String BASE_URL = "https://nikke-kr.com/art.html?active_tab=1864";
  private int currentPage = 0;
  private static final int TOTAL_PAGES = 16; // Adjust this if needed

  public NikkePagedImageRetrievalService(WebDriver webDriver) {
    super(webDriver);
  }

  @Override
  protected void navigateToFirstPage() {
    currentPage = 0;
    webDriver.get(BASE_URL);
    waitForPageLoad();
    clickTab("모바일 배경화면");
    waitForPageLoad(); // Wait for the content to load after tab change
  }

  private void clickTab(String tabText) {
    WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofSeconds(30));
    try {
      WebElement tab = wait.until(ExpectedConditions.elementToBeClickable(By.xpath(
          String.format("//div[@class='child-tab-item' and text()='%s']", tabText))));
      ((JavascriptExecutor) webDriver).executeScript("arguments[0].click();", tab);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  @Override
  protected boolean navigateToNextPage() {
    return navigateToPage(currentPage + 1);
  }

  private boolean navigateToPage(int pageNumber) {
    if (pageNumber < 0 || pageNumber >= TOTAL_PAGES) {
      return false; // Page number is out of bounds
    }

    WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofSeconds(30));
    try {
      // Find the page icon element for the desired page
      WebElement pageIcon = wait.until(ExpectedConditions.elementToBeClickable(By.xpath(
          String.format("//ul[@class='page-icons']//li[@data-page='%d']", pageNumber))));
      ((JavascriptExecutor) webDriver).executeScript("arguments[0].click();", pageIcon);

      // Wait for images to load
      waitForImagesToLoad();

      // Update the current page number
      currentPage = pageNumber;

      // Wait for the page to fully load with a 1-second delay
      Thread.sleep(1000); // Adding a delay to ensure that the page fully loads
      waitForPageLoad();
      return true;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }

  private void waitForPageLoad() {
    WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofSeconds(30));
    wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector(".art-container")));
  }

  private void waitForImagesToLoad() {
    WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofSeconds(30));
    try {
      // Wait until the images are present on the page
      wait.until(ExpectedConditions.presenceOfAllElementsLocatedBy(
          By.xpath("//div[@class='list w-vertical']//div[@class='item']//img")));
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  @Override
  protected List<String> extractImageUrlsFromPage() {
    List<String> imageUrls = new ArrayList<>();
    WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofSeconds(30));

    try {
      List<WebElement> imageElements = wait.until(ExpectedConditions.presenceOfAllElementsLocatedBy(
          By.xpath("//div[@class='list w-vertical']//div[@class='item']//img")));

      for (WebElement imageElement : imageElements) {
        String imageUrl = imageElement.getAttribute("src");
        if (imageUrl != null && !imageUrl.isEmpty()) {
          imageUrls.add(imageUrl);
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
    }

    return imageUrls;
  }

  @Override
  public String getGameName() {
    return "nikke";
  }
}
