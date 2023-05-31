import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class DungeonAndFighterWallpaperRepository extends AbstractWallpaperRepository {
  DungeonAndFighterWallpaperRepository()
      : super('https://df.nexon.com/df/pg/dfonwallpaper');

  @override
  List<String> parsePaging(http.Response response) {
    final document = getDocument(response.body);
    return document
        .getElementById("wallpaper_container")!
        .querySelectorAll('a')
        .map((a) => a.attributes['href']!)
        .toSet()
        .toList();
  }

  @override
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
