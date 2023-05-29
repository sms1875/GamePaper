import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/repository/blackdesert_wallpaper_repository.dart';

class BlackDesertWallpaperProvider extends WallpaperProvider {
  BlackDesertWallpaperProvider() : super(BlackDesertWallpaperRepository());
}
