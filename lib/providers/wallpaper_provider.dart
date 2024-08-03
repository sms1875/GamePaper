import 'package:wallpaper/repository/wallpaper_repository.dart';
import 'package:wallpaper/providers/abstract_wallpaper_provider.dart';

class WallpaperProvider extends AbstractWallpaperProvider {
  WallpaperProvider(WallpaperRepository wallpaperRepository) : super(wallpaperRepository);
}
