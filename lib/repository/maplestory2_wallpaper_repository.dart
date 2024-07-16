import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class MapleStory2WallpaperRepository extends BaseWallpaperRepository {
  MapleStory2WallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    pagingElementSelector: '.paginate > span.num a',
    imageElementSelector:'.result_sec',
    imageAttributeName: 'href',
  );
}
