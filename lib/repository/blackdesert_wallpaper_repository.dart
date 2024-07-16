import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class BlackDesertWallpaperRepository extends BaseWallpaperRepository {
  BlackDesertWallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    pagingElementSelector: 'div.paging > a',
    pagingAttributeName: 'href',
    imageElementSelector: '#wallpaper_list > li > a[attr-img_m]',
    imageAttributeName: 'attr-img_m',
    pagingUrlPrefix: baseUrl,
  );
}