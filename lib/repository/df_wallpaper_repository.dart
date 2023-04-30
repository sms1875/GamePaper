import 'package:html/parser.dart';
import 'package:wallpaper/data/df_wallpaper.dart';
import 'package:http/http.dart' as http;

class DungeonAndFighterWallpaperRepository {

  Future<DungeonAndFighterWallpaper> fetchDungeonAndFighterWallpaper() async {
    String baseUrl = 'https://df.nexon.com/df/pg/dfonwallpaper';
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      final paging = document.getElementById("wallpaper_container")
      !.querySelectorAll('a')
          .map((a) => a.attributes['href']!)
          .toSet()
          .toList();

      List<List<String>> pageUrls = [];
      int pageSize = 20; // 페이지당 아이템 수
      int pageCount = (paging.length / pageSize).ceil(); // 총 페이지 수
      for (int i = 0; i < pageCount; i++) {
        List<String> page = [];
        for (int j = 0; j < pageSize && i * pageSize + j < paging.length; j++) {
          page.add(paging[i * pageSize + j]);
        }
        pageUrls.add(page);
      }

      final wallpapers = await fetchPage(1, pageUrls); //초기화면
      return DungeonAndFighterWallpaper(
        page: 1,
        pageUrls: pageUrls,
        wallpapers: wallpapers,
      );
    } else {
      throw Exception('Failed to load HTML');
    }
  }

  Future<List<Map<String, String>>> fetchPage(int page, List<List<String>> pageUrls) async {
    String baseUrl = 'https://df.nexon.com/df/pg/dfonwallpaper';
    List<String> urls = pageUrls[page-1];
    List<Map<String, String>> wallpapers = [];

    for (String url in urls) {
      final response = await http.get(Uri.parse('$baseUrl$url'));
      final document = parse(response.body);
      wallpapers.addAll(
          document
              .getElementsByClassName("wp_more_img").map((div) {
            final src = div.querySelector('img')?.attributes['src'] ?? '';
            return
              {'src': "https:$src"};
          }).toList());
    }

    return wallpapers;
  }
}
