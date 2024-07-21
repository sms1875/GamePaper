import 'package:wallpaper/repository/wallpaper_repository.dart';
import 'wallpaper_provider.dart';

class WallpaperProviderFactory {
  static WallpaperProvider createProvider(
      WallpaperRepository repository) {
    return WallpaperProvider(repository);
  }
}
