import 'package:wallpaper/repository/wallpaper_repository.dart';

class MonsterHunterWallpaperRepository extends WallpaperRepository {
  MonsterHunterWallpaperRepository()
      : super('https://www.monsterhunter.com/mha/en/wallpaper_gift/');

  @override
  List<String> parsePaging(response) {
    final document = getDocument(response.body);
    return document
        .querySelectorAll('.wallpaperBox_ver > ul > li > p.btn > a')
        .map((a) => a.attributes['href']!)
        .toSet()
        .toList();
  }

  @override
  Future<Map<String, String>> fetchWallpaperInfo(String url) async {
    return {'src': "https://www.monsterhunter.com/$url", 'url': "https://www.monsterhunter.com/$url"};
  }
}