import 'package:wallpaper/provider/abstract_wallpaper_provider.dart';
import 'package:wallpaper/repository/apexlegends_wallpaper_repository.dart';
import 'package:wallpaper/repository/heavenburnsred_wallpaper_repository.dart';

class HeavenBurnsRedWallpaperProvider extends AbstractWallpaperProvider {
  HeavenBurnsRedWallpaperProvider() : super(HeavenBurnsRedWallpaperRepository());
}
