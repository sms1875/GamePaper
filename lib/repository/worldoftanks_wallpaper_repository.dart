import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class WorldOfTanksWallpaperRepository extends BaseWallpaperRepository {
  WorldOfTanksWallpaperRepository(String baseUrl) : super(
    baseUrl: baseUrl,
    pagingElementSelector: '.content-wrapper .b-pager_item__pages a:last-child',
    imageElementSelector: '.content-wrapper',
    imageAttributeName: 'href',
  );
}