import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/repository/mabinogi_wallpaper_repository.dart';

class MabinogiWallpaperProvider extends WallpaperProvider {
  MabinogiWallpaperProvider() : super(MabinogiWallpaperRepository());
}
