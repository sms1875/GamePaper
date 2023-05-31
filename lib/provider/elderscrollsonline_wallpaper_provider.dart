import 'package:wallpaper/provider/abstract_wallpaper_provider.dart';
import 'package:wallpaper/repository/elderscrollsonline_wallpaper_repository.dart';

class ElderScrollsOnlineWallpaperProvider extends AbstractWallpaperProvider {
  ElderScrollsOnlineWallpaperProvider() : super(ElderScrollsOnlineWallpaperRepository());
}
