import 'package:wallpaper/provider/abstract_wallpaper_provider.dart';
import 'package:wallpaper/repository/priconne_wallpaper_repository.dart';

class PriConneWallpaperProvider extends AbstractWallpaperProvider {
  PriConneWallpaperProvider() : super(PriConneWallpaperRepository());
}
