import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/repository/eldenring_wallpaper_repository.dart';

class EldenRingWallpaperProvider extends WallpaperProvider {
  EldenRingWallpaperProvider() : super(EldenRingWallpaperRepository());
}
