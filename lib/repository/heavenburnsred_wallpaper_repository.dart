import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class HeavenBurnsRedWallpaperRepository extends AbstractWallpaperRepository {
  HeavenBurnsRedWallpaperRepository()
      : super('https://heaven-burns-red.com/fankit/sp-wallpaper/');

  @override
  List<String> parsePaging(response) {
    final document = getDocument(response.body);
    return document
        .querySelectorAll('.post-content > ul > li > div.clm-buttons > a')
        .map((a) => a.attributes['href']!.replaceFirst('../../', ''))
        .where((href) => href.contains('iphone.png'))
        .toList();
  }

  @override
  Future<Map<String, String>> fetchWallpaperInfo(String url) async {
    return {'src': "https://heaven-burns-red.com/$url", 'url': "https://heaven-burns-red.com/$url"};
  }
}