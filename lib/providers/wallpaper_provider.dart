import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';
import 'package:wallpaper/providers/abstract_wallpaper_provider.dart';

class WallpaperProvider extends AbstractWallpaperProvider {
  WallpaperProvider(BaseWallpaperRepository wallpaperRepository) : super(wallpaperRepository);
}