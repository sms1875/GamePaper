import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class ApexLegendsWallpaperRepository extends BaseWallpaperRepository {
  ApexLegendsWallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    imageElementSelector: 'ea-game-box a',
    imageAttributeName: 'href',
    imageUrlFilter: (href) => href.contains('mobile'),
  );
}