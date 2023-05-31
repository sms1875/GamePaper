import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/data/wallpaper.dart';

abstract class WallpaperRepository {
  String baseUrl;
  Wallpaper? cachedWallpaper;
  Map<int, List<Map<String, String>>> pageCaches = {};

  WallpaperRepository(this.baseUrl);

  Future<Wallpaper> fetchWallpaper() async {
    if (cachedWallpaper != null) {
      return cachedWallpaper!;
    }

    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final paging = parsePaging(response);
      final pageUrlsList = generatePageUrlsList(paging);
      final wallpapers = await fetchPageCache(1, pageUrlsList); // 초기화면
      final wallpaperData = Wallpaper(
        page: 1,
        pageUrlsList: pageUrlsList,
        wallpapers: wallpapers,
      );
      cachedWallpaper = wallpaperData;
      return wallpaperData;
    } else {
      throw Exception('Failed to load HTML');
    }
  }

  Document getDocument(String responseBody) {
    return parse(responseBody);
  }

  //List<dynamic> 형식으로 반환되서 getDocument 따로 만들어서 사용
  List<String> parsePaging(http.Response response);

  //사이트에서 페이지가 없을 경우 [[url1, url2, url3, ...], [url21, url22, url23, ...], ...]로 분할
  //페이지가 존재할 경우 [[$page=1], [$page=2], ...]로 각 페이지 요청
  List<List<String>> generatePageUrlsList(List<String> paging) {
    int pageSize = 20;
    return List.generate(
      (paging.length / pageSize).ceil(),
          (i) => paging.skip(i * pageSize).take(pageSize).toList(),
    );
  }

  Future<List<Map<String, String>>> fetchPageCache(int page, List<List<String>> pageUrlsList) async {
    if (pageCaches.containsKey(page)) {
      return pageCaches[page]!;
    } else {
      List<Map<String, String>> results = await fetchPage(page, pageUrlsList);
      pageCaches[page] = results;
      return results;
    }
  }

  Future<List<Map<String, String>>> fetchPage(int page, List<List<String>> pageUrlsList) async {
    List<String> urls = pageUrlsList[page - 1];
    List<Future<Map<String, String>>> futures = urls.map((url) => fetchWallpaperInfo(url)).toList();
    List<Map<String, String>> results = await Future.wait(futures);
    results.sort((a, b) => urls.indexOf(a['url']!).compareTo(urls.indexOf(b['url']!)));
    return results;
  }

  Future<Map<String, String>> fetchWallpaperInfo(String url);
}
