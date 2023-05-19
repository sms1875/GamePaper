import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/data/wallpaper.dart';

class DungeonAndFighterWallpaperRepository {
  String baseUrl = 'https://df.nexon.com/df/pg/dfonwallpaper';
  PagingWallpaper? cachedWallpaper;

  Future<PagingWallpaper> fetchDungeonAndFighterWallpaper() async {
    if (cachedWallpaper != null) {
      return cachedWallpaper!;
    }

    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      final paging = document
          .getElementById("wallpaper_container")!
          .querySelectorAll('a')
          .map((a) => a.attributes['href']!)
          .toSet()
          .toList();

      int pageSize = 20;
      List<List<String>> pageUrlsList = List.generate(
          (paging.length / pageSize).ceil(),
              (i) => paging.skip(i * pageSize).take(pageSize).toList());

      final wallpapers = await fetchPage(1, pageUrlsList); //초기화면
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
    final response = await http.get(Uri.parse('$baseUrl$url'));
    final document = parse(response.body);
    final src = document
        .getElementsByClassName("wp_more_img")
        .first
        .querySelector('img')?.attributes['src'] ?? '';
    return {'src': "https:$src", 'url': url};
  }
}
