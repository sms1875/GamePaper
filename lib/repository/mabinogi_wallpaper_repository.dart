import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class MabinogiWallpaperRepository extends BaseWallpaperRepository {
  MabinogiWallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    imageElementSelector: '#div_contents > div.board_wrap01 > div.board_data02 > ul > li > a',
    imageAttributeName: 'href',
    imageUrlPattern: RegExp(r"javascript:viewWall2\('(.*?)', \d+\)"),
    imageUrlReplacement: r'$1',
    imageUrlFilter: (href) => href.contains('1125x2436'),
    imageUrlGroupNumber: 1,
  );
}