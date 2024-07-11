import 'package:wallpaper/screen/abstract_wallpaper_screen.dart';
import 'package:wallpaper/provider/abstract_wallpaper_provider.dart';

class ConcreteWallpaperScreen extends AbstractWallpaperScreen {
  const ConcreteWallpaperScreen({super.key, required AbstractWallpaperProvider wallpaperProvider})
      : super(wallpaperProvider: wallpaperProvider);
}