import 'package:wallpaper/provider/abstract_wallpaper_provider.dart';
import 'package:wallpaper/repository/blackdesert_wallpaper_repository.dart';

class BlackDesertWallpaperProvider extends AbstractWallpaperProvider {
  BlackDesertWallpaperProvider() : super(BlackDesertWallpaperRepository());
}
