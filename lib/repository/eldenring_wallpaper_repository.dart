import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/data/wallpaper.dart';

class EldenRingWallpaperRepository {
  String baseUrl = 'https://eldenring.bn-ent.net/';
  String wallpaperUrl = 'kr/special/';
  PagingWallpaper? cachedWallpaper;

  Future<PagingWallpaper> fetchEldenRingWallpaper() async {
    if (cachedWallpaper != null) {
      return cachedWallpaper!;
    }

    final response = await http.get(Uri.parse(baseUrl + wallpaperUrl));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      final paging = document
          .querySelectorAll('.wpList li')
          .map((li) => li.querySelector('a[href*="1125x2436"]'))
          .where((a) => a != null)
          .map((a) => a!.attributes['href']!.replaceFirst('../../', ''))
          .toList();

      int pageSize = 20;
      List<List<String>> pageUrlsList = List.generate(
          (paging.length / pageSize).ceil(),
              (i) => paging.skip(i * pageSize).take(pageSize).toList());

      final wallpapers = await fetchPage(1, pageUrlsList); // 초기화면
      final wallpaperData = PagingWallpaper(
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

  Future<List<Map<String, String>>> fetchPage(int page, List<List<String>> pageUrls) async {
    List<String> urls = pageUrls[page - 1];
    List<Future<Map<String, String>>> futures = urls.map((url) => fetchWallpaperInfo(url)).toList();
    List<Map<String, String>> results = await Future.wait(futures);
    results.sort((a, b) => urls.indexOf(a['url']!).compareTo(urls.indexOf(b['url']!)));

    return results;
  }

  Future<Map<String, String>> fetchWallpaperInfo(String url) async {
    return {'src': baseUrl + url, 'url': baseUrl + url};
  }
}
