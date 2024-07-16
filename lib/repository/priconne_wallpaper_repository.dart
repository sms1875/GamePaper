import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class PriConneWallpaperRepository extends BaseWallpaperRepository {
  PriConneWallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    pagingElementSelector: '.pager > ul > li > a',
    imageElementSelector:'.fankit-list > li > a',
    imageAttributeName: 'href',
    imageUrlFilter: (href) => href != 'javascript:void(0)',
  );
}
