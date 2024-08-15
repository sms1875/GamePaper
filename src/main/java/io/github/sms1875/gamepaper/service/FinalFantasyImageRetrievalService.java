package io.github.sms1875.gamepaper.service;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service("finalfantasy")
public class FinalFantasyImageRetrievalService extends AbstractGameImageRetrievalService {

  private static final String BASE_URL = "https://na.finalfantasyxiv.com/lodestone/special/fankit/smartphone_wallpaper/";
  private static final String[] EXPANSIONS = { "7_0", "6_0", "5_0", "4_0", "3_0", "2_0" };
  private static final String USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36";

  public FinalFantasyImageRetrievalService() {
    super(null); // Jsoup 사용 시 WebDriver가 필요하지 않으므로 null로 설정
  }

  @Override
  public List<String> getImageUrls() {
    List<String> imageUrls = new ArrayList<>();
    try {
      for (String expansion : EXPANSIONS) {
        Document document = navigateToPage(expansion);
        imageUrls.addAll(extractImageUrlsFromPage(document));
      }
    } catch (Exception e) {
      handleException(e);
    }
    return imageUrls;
  }

  private Document navigateToPage(String expansion) throws IOException {
    String url = BASE_URL + expansion + "/#nav_fankit";
    return Jsoup.connect(url)
        .userAgent(USER_AGENT)
        .timeout(10000) // 10초 타임아웃 설정
        .get();
  }

  private List<String> extractImageUrlsFromPage(Document document) {
    List<String> imageUrls = new ArrayList<>();
    Elements wallpaperElements = document.selectXpath("//*[@id=\"pc_wallpaper\"]/div/div/ul[2]/li/p/a[3]");
    for (Element element : wallpaperElements) {
      String imgUrl = element.attr("href");
      if (isValidUrl(imgUrl)) {
        imageUrls.add(imgUrl);
      }
    }
    return imageUrls;
  }

  @Override
  protected List<String> extractImageUrlsFromPage() {
    return new ArrayList<>();
  }
}
