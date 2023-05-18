import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/data/wallpaper.dart';

class ApexLegendsWallpaperRepository {
  String baseUrl = 'https://www.ea.com/ko-kr/games/apex-legends/media#wallpapers';
  PagingWallpaper? cachedWallpaper;

  Future<PagingWallpaper> fetchApexLegendsWallpaper() async {
    if (cachedWallpaper != null) {
      return cachedWallpaper!;
    }

    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      final paging = document
          .querySelectorAll('ea-game-box a')
          .map((a) => a.attributes['href']!)
          .where((href) => href.contains('mobile'))
          .toList();
      int pageSize = 20;
      List<List<String>> pageUrlsList = List.generate(
          (paging.length / pageSize).ceil(),
              (i) => paging.skip(i * pageSize).take(pageSize).toList());

      print(pageUrlsList);
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
    List<Map<String, String>> wallpapers = [];

    List<Future<Map<String, String>>> futures = urls.map((url) async {
      return {'src': url, 'url': url};
    }).toList();

    List<Map<String, String>> results = await Future.wait(futures);
    results.sort((a, b) => urls.indexOf(a['url']!).compareTo(urls.indexOf(b['url']!)));
    wallpapers.addAll(results);

    return wallpapers;
  }
}
