import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class MabinogiWallpaperRepository extends AbstractWallpaperRepository {
  MabinogiWallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    selector: '#div_contents > div.board_wrap01 > div.board_data02 > ul > li > a',
    attributeName: 'href',
    customFilterCondition: (href) => href.contains('1125x2436'),
  );

  @override
  String? extractHref(element) {
    final href = element.attributes['href'];
    if (href == null) return null;
    final regex = RegExp(r"viewWall2\('(.+?)',");
    final match = regex.firstMatch(href);
    return match?.group(1);
  }
}