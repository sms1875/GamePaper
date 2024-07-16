import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';
import 'wallpaper_provider.dart';

class WallpaperProviderFactory {
  static WallpaperProvider createProvider(
      BaseWallpaperRepository repository) {
    return WallpaperProvider(repository);
  }
}
