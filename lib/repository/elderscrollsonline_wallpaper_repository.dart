import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class ElderScrollsOnlineWallpaperRepository extends BaseWallpaperRepository {
  ElderScrollsOnlineWallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    imageElementSelector: '#media-category > div > section > a[data-zl-title*="750x1334"]',
    imageAttributeName: 'data-zl-title',
    imageUrlPattern: RegExp(r"<a href='([^']+)'\s+target='_blank'>750x1334</a>"),
    imageUrlGroupNumber: 1,
  );
}