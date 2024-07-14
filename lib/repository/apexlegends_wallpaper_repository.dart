import 'package:http/http.dart' as http;
import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class ApexLegendsWallpaperRepository extends AbstractWallpaperRepository {
  ApexLegendsWallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    selector: 'ea-game-box a',
    attributeName: 'href',
    customFilterCondition: (href) => href.contains('mobile'),
  );
}