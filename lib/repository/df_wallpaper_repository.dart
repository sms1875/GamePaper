import 'package:html/parser.dart';
import 'package:wallpaper/data/wallpaper.dart';
import 'package:http/http.dart' as http;

class DungeonAndFighterWallpaperRepository {

  Future<Wallpaper> fetchDungeonAndFighterWallpaper(int page) async {
    String baseUrl = 'https://df.nexon.com/df/pg/dfonwallpaper';
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      final paging = document.getElementById("wallpaper_container");
      final pageUrls = paging
          ?.querySelectorAll('a')
          .map((a) => a.attributes['href']!)
          .toSet()
          .toList();

      List<Map<String, String>> wallpapers = [];
      for (final pageUrl in pageUrls!) {
        final pageData = await fetchPage('$baseUrl$pageUrl');
        wallpapers.addAll(pageData);
      }
      return Wallpaper(
        page: page,
        pageUrls: pageUrls,
        wallpapers: wallpapers,
      );
    } else {
      throw Exception('Failed to load HTML');
    }
  }

  Future<List<Map<String, String>>> fetchPage(String pageUrl) async {
    final response = await http.get(Uri.parse(pageUrl));
    final document = parse(response.body);
    var wpmoreimg = document.getElementsByClassName("wp_more_img");
    final wallpapers = wpmoreimg
        .map((div) {
      final src = div.querySelector('img')?.attributes['src'] ?? '';
      return {
        'src': "https:$src"
      };
    }).toList() ?? [];
    return wallpapers;
  }
}
