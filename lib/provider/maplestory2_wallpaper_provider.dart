import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/repository/maplestory2_wallpaper_repository.dart';

class MapleStory2WallpaperProvider extends WallpaperProvider {
  MapleStory2WallpaperProvider() : super(MapleStory2WallpaperRepository());
}
