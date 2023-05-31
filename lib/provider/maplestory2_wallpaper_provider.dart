import 'package:wallpaper/provider/abstract_wallpaper_provider.dart';
import 'package:wallpaper/repository/maplestory2_wallpaper_repository.dart';

class MapleStory2WallpaperProvider extends AbstractWallpaperProvider {
  MapleStory2WallpaperProvider() : super(MapleStory2WallpaperRepository());
}
