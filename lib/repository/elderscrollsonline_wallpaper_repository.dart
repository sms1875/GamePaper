import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class ElderScrollsOnlineWallpaperRepository extends BaseWallpaperRepository {
  ElderScrollsOnlineWallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    imageElementSelector: '#media-category > div > section > a[data-zl-title*="750x1334"]',
    imageAttributeName: 'data-zl-title',
  );
}