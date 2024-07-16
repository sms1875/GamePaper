import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class EldenRingWallpaperRepository extends BaseWallpaperRepository {
  EldenRingWallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    imageElementSelector: '#specialCol > ul.wpList > li > p > a',
    imageAttributeName: 'href',
    imageUrlFilter: (href) => href.contains('1125x2436'),
    imageUrlPrefix: "https://eldenring.bn-ent.net/",
    imageUrlGroupNumber: 0,
  );
}