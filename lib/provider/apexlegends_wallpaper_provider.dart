import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/repository/apexlegends_wallpaper_repository.dart';

class ApexLegendsWallpaperProvider extends WallpaperProvider {
  ApexLegendsWallpaperProvider() : super(ApexLegendsWallpaperRepository());
}
