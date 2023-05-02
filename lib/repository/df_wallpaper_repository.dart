import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/data/wallpaper.dart';

class DungeonAndFighterWallpaperRepository {
  String baseUrl = 'https://df.nexon.com/df/pg/dfonwallpaper';

  Future<DungeonAndFighterWallpaper> fetchDungeonAndFighterWallpaper() async {
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
      return DungeonAndFighterWallpaper(
        page: 1,
        pageUrlsList: pageUrlsList,
        wallpapers: wallpapers,
      );
    } else {
      throw Exception('Failed to load HTML');
    }
  }

  Future<List<Map<String, String>>> fetchPage(int page, List<List<String>> pageUrls) async {
    List<String> urls = pageUrls[page - 1];
    List<Map<String, String>> wallpapers = [];

    List<Future<Map<String, String>>> futures = urls.map((url) async {
      final response = await http.get(Uri.parse('$baseUrl$url'));
      final document = parse(response.body);
      final src = document
          .getElementsByClassName("wp_more_img")
          .first
          .querySelector('img')?.attributes['src'] ?? '';
      return {'src': "https:$src", 'url': url};
    }).toList();

    List<Map<String, String>> results = await Future.wait(futures);
    results.sort((a, b) => urls.indexOf(a['url']!).compareTo(urls.indexOf(b['url']!)));
    wallpapers.addAll(results);

    return wallpapers;
  }
}
