import 'package:wallpaper/repository/wallpaper_repository.dart';

class MabinogiWallpaperRepository extends WallpaperRepository {
  MabinogiWallpaperRepository()
      : super('https://mabinogi.nexon.com/page/pds/gallery_wallpaper.asp');

  @override
  List<String> parsePaging(response) {
    final document = getDocument(response.body);

    //"javascript:viewWall2('https://ssl.nexon.com/s2/game/mabinogi/MabiWeb/wallpaper/illust_088_1125x2436.jpg', 6)" 파싱
    final hrefList = document
        .getElementById('div_contents')!
        .querySelectorAll('a')
        .map((a) => a.attributes['href']!)
        .where((href) => href.contains('1125x2436'))
        .map((href) {
      final startIndex = href.indexOf("'") + 1;
      final endIndex = href.lastIndexOf("'");
      final imageUrl = href.substring(startIndex, endIndex);
      return imageUrl;
    }).toList();

    return hrefList;
  }

  @override
  Future<Map<String, String>> fetchWallpaperInfo(String url) async {
    return {'src': url, 'url': url };
  }
}