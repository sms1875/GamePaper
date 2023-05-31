import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/repository/elderscrollsonline_wallpaper_repository.dart';

class ElderScrollsOnlineWallpaperProvider extends WallpaperProvider {
  ElderScrollsOnlineWallpaperProvider() : super(ElderScrollsOnlineWallpaperRepository());
}
