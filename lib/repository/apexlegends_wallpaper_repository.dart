import 'package:http/http.dart' as http;
import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class ApexLegendsWallpaperRepository extends AbstractWallpaperRepository {
  ApexLegendsWallpaperRepository()
      : super('https://www.ea.com/ko-kr/games/apex-legends/media#wallpapers');

  @override
  List<String> parsePaging(http.Response response) {
    final document = getDocument(response.body);
    return document
        .querySelectorAll('ea-game-box a')
        .map((a) => a.attributes['href']!)
        .where((href) => href.contains('mobile'))
        .toList();
  }

  @override
  Future<Map<String, String>> fetchWallpaperInfo(String url) async {
    return {'src': url, 'url': url};
  }
}
