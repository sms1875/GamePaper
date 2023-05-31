import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class ElderScrollsOnlineWallpaperRepository extends AbstractWallpaperRepository {
  ElderScrollsOnlineWallpaperRepository()
      : super('https://www.elderscrollsonline.com/en-us/media/category/wallpapers/');

  @override
  List<String> parsePaging(response) {
    final document = getDocument(response.body);

    final hrefs = document
        .getElementById('media-category')!
        .querySelectorAll('a[data-zl-title*="750x1334"]')
        .map((a) => a.attributes['data-zl-title']!.split('|'))
        .expand((list) => list)
        .map((str) => str.trim())
        .where((str) => str.contains('750x1334'))
        .map((str) => str.substring(str.indexOf('\'')+1, str.lastIndexOf('target')));

    print(hrefs);

    return hrefs.toList();
  }

  @override
  Future<Map<String, String>> fetchWallpaperInfo(String url) async {
    return {'src': url, 'url': url};
  }
}