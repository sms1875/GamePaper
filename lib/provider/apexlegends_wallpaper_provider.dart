import 'package:wallpaper/provider/abstract_wallpaper_provider.dart';
import 'package:wallpaper/repository/apexlegends_wallpaper_repository.dart';

class ApexLegendsWallpaperProvider extends AbstractWallpaperProvider {
  ApexLegendsWallpaperProvider() : super(ApexLegendsWallpaperRepository());
}
