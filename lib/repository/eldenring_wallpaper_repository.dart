import 'package:wallpaper/repository/wallpaper_repository.dart';

class EldenRingWallpaperRepository extends WallpaperRepository {
  EldenRingWallpaperRepository()
      : super('https://eldenring.bn-ent.net/kr/special/');

  @override
  List<String> parsePaging(response) {
    final document = getDocument(response.body);
    return document
        .querySelectorAll('.wpList li')
        .map((li) => li.querySelector('a[href*="1125x2436"]'))
        .where((a) => a != null)
        .map((a) => a!.attributes['href']!.replaceFirst('../../', ''))
        .toList();
  }

  @override
  Future<Map<String, String>> fetchWallpaperInfo(String url) async {
    return {'src': "https://eldenring.bn-ent.net/$url", 'url': "https://eldenring.bn-ent.net/$url"};
  }
}