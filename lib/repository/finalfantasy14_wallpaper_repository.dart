import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class FinalFantasy14WallpaperRepository extends BaseWallpaperRepository {
  FinalFantasy14WallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    pagingElementSelector: '#pc_wallpaper > div > div > ul.nav_select.clearfix > li > a',
    pagingAttributeName: 'href',
    imageElementSelector:'#pc_wallpaper > div > div > ul.list_sp_wallpaper.clearfix > li > p > a',
    imageAttributeName: 'href',
    pagingUrlFilter: (href) => href.contains('smartphone_wallpaper'),
    pagingUrlPrefix: 'https://na.finalfantasyxiv.com/',
  );
}