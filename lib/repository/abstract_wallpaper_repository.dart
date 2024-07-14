import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/models/wallpaper.dart';

abstract class AbstractWallpaperRepository {
  String baseUrl;
  Wallpaper? cachedWallpaper;
  Map<int, List<Map<String, String>>> pageCaches = {};

  String selector;
  String attributeName;
  bool needsReplace;
  String? replaceFrom;
  String? replaceTo;
  bool Function(String)? customFilterCondition;
  String? urlPattern;
  String urlReplacement;

  AbstractWallpaperRepository({
    required this.baseUrl,
    required this.selector,
    required this.attributeName,
    this.needsReplace = false,
    this.replaceFrom,
    this.replaceTo,
    this.customFilterCondition,
    this.urlPattern,
    this.urlReplacement = r'$0',
  });

  Future<Wallpaper> fetchWallpaper() async {
    if (cachedWallpaper != null) {
      return cachedWallpaper!;
    }

    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final paging = parsePaging(response);
      final pageUrlsList = generatePageUrlsList(paging);
      final wallpapers = await fetchPageCache(1, pageUrlsList);
      final wallpaperData = Wallpaper(
        page: 1,
        pageUrlsList: pageUrlsList,
        wallpapers: wallpapers,
      );
      cachedWallpaper = wallpaperData;
      return wallpaperData;
    } else {
      throw Exception('Failed to get fetchWallpaper');
    }
  }

  BeautifulSoup getDocument(String responseBody) {
    return BeautifulSoup(responseBody);
  }

  List<String> parsePaging(http.Response response) {
    final document = getDocument(response.body);
    return document
        .findAll(selector)
        .map((element) => extractHref(element))
        .where((href) => href != null && filterCondition(href))
        .toSet()
        .toList()
        .cast<String>();
  }

  String? extractHref(element) {
    String? href = element.attributes[attributeName];
    if (needsReplace && href != null && replaceFrom != null && replaceTo != null) {
      href = href.replaceFirst(replaceFrom!, replaceTo!);
    }
    return href;
  }

  bool filterCondition(String href) {
    return customFilterCondition?.call(href) ?? true;
  }

  // 사이트에서 페이지가 없을 경우 [[url1, url2, url3, ...], [url21, url22, url23, ...], ...]로 분할
  // 페이지가 존재할 경우 [[$page=1], [$page=2], ...]로 각 페이지 요청
  List<List<String>> generatePageUrlsList(List<String> paging) {
    int pageSize = 21;
    return List.generate(
      (paging.length / pageSize).ceil(),
          (i) => paging.skip(i * pageSize).take(pageSize).toList(),
    );
  }

  Future<List<String>> fetchPageCache(int page, List<List<String>> pageUrlsList) async {
    if (pageCaches.containsKey(page)) {
      return pageCaches[page]!.map((map) => map['url']!).toList();
    } else {
      List<String> results = await fetchPage(page, pageUrlsList);
      pageCaches[page] = results.map((url) => {'url': url}).toList();
      return results;
    }
  }

  Future<List<String>> fetchPage(int page, List<List<String>> pageUrlsList) async {
    List<String> urls = pageUrlsList[page - 1];
    List<Future<String>> futures = urls.map((url) => fetchWallpaperInfo(url)).toList();

    List<String> results = await Future.wait(futures);
    return results;
  }

  Future<String> fetchWallpaperInfo(String url) async {
    if (urlPattern != null) {
      return url.replaceAllMapped(RegExp(urlPattern!), (match) {
        String result = urlReplacement;
        for (int i = 0; i <= match.groupCount; i++) {
          result = result.replaceAll('\$$i', match.group(i) ?? '');
        }
        return result;
      });
    }
    return url;
  }
}
