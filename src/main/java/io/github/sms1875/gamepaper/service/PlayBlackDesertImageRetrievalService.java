package io.github.sms1875.gamepaper.service;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service("playblackdesert")
public class PlayBlackDesertImageRetrievalService extends AbstractGameImageRetrievalService {

  // URL과 셀렉터를 상수로 선언하여 관리하기 쉽게 만듭니다.
  private static final String BASE_URL = "https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/";
  private static final String USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36";
  private static final String WALLPAPER_LIST_SELECTOR = "#wallpaper_list li a";
  private static final String NEXT_PAGE_SELECTOR = "#paging .btn_arrow.next:not(.nopage)";
  private static final String IMG_ATTRIBUTE = "attr-img_m";

  public PlayBlackDesertImageRetrievalService() {
    super(null); // Jsoup 사용 시 WebDriver가 필요하지 않으므로 null로 설정
  }

  /**
   * 지정된 URL에서 월페이퍼 이미지 URL 목록을 가져옵니다.
   *
   * @return 이미지 URL 리스트
   */
  @Override
  public List<String> getImageUrls() {
    List<String> imageUrls = new ArrayList<>();
    try {
      Document document = connectToPage(BASE_URL);

      do {
        imageUrls.addAll(extractImageUrlsFromPage(document));
      } while ((document = navigateToNextPage(document)) != null);

    } catch (IOException e) {
      handleException(e);
    }
    return imageUrls;
  }

  /**
   * 주어진 URL로 연결하여 Document 객체를 반환합니다.
   *
   * @param url 연결할 페이지의 URL
   * @return Document 객체
   * @throws IOException 연결 실패 시 예외 발생
   */
  private Document connectToPage(String url) throws IOException {
    return Jsoup.connect(url)
        .userAgent(USER_AGENT)
        .timeout(10000) // 타임아웃을 설정하여 연결이 너무 오래 걸리지 않도록 합니다.
        .get();
  }

  /**
   * 현재 페이지에서 다음 페이지로 이동하고, 그 페이지의 Document 객체를 반환합니다.
   *
   * @param currentPage 현재 페이지의 Document 객체
   * @return 다음 페이지의 Document 객체, 더 이상 페이지가 없으면 null
   */
  private Document navigateToNextPage(Document currentPage) {
    try {
      Element nextPageElement = currentPage.selectFirst(NEXT_PAGE_SELECTOR);
      if (nextPageElement != null) {
        String nextPageUrl = nextPageElement.absUrl("href");
        return connectToPage(nextPageUrl);
      }
    } catch (IOException e) {
      handleException(e);
    }
    return null;
  }

  /**
   * 주어진 페이지의 Document 객체에서 이미지 URL을 추출하여 리스트로 반환합니다.
   *
   * @param document 페이지의 Document 객체
   * @return 이미지 URL 리스트
   */
  protected List<String> extractImageUrlsFromPage(Document document) {
    List<String> pageImageUrls = new ArrayList<>();
    Elements wallpaperElements = document.select(WALLPAPER_LIST_SELECTOR);

    for (Element element : wallpaperElements) {
      String imgUrl = element.attr(IMG_ATTRIBUTE);
      if (isValidUrl(imgUrl)) {
        pageImageUrls.add(imgUrl);
      }
    }
    return pageImageUrls;
  }

  /**
   * 이미지 URL이 유효한지 검사합니다.
   *
   * @param url 검사할 URL
   * @return 유효한 URL이면 true, 그렇지 않으면 false
   */
  private boolean isValidUrl(String url) {
    return url != null && url.startsWith("http");
  }

  /**
   * 예외가 발생했을 때 처리하는 메서드.
   *
   * @param e 발생한 예외
   */
  private void handleException(IOException e) {
    // 로그를 남기고 예외를 처리할 수 있습니다. 예를 들어:
    e.printStackTrace();
    // 로깅 프레임워크를 사용하는 경우, e.printStackTrace() 대신 로그를 기록하세요.
  }

  @Override
  protected List<String> extractImageUrlsFromPage() {
    // Jsoup을 사용하는 경우, 이 메서드는 사용되지 않으므로 빈 리스트를 반환합니다.
    return new ArrayList<>();
  }
}
