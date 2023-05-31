import 'package:wallpaper/provider/abstract_wallpaper_provider.dart';
import 'package:wallpaper/repository/eldenring_wallpaper_repository.dart';

class EldenRingWallpaperProvider extends AbstractWallpaperProvider {
  EldenRingWallpaperProvider() : super(EldenRingWallpaperRepository());
}
