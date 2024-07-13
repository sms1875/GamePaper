import 'package:wallpaper/screens/abstract_wallpaper_screen.dart';
import 'package:wallpaper/providers/abstract_wallpaper_provider.dart';

class ConcreteWallpaperScreen extends AbstractWallpaperScreen {
  const ConcreteWallpaperScreen({super.key, required AbstractWallpaperProvider wallpaperProvider})
      : super(wallpaperProvider: wallpaperProvider);
}