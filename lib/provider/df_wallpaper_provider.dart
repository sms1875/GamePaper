import 'package:wallpaper/provider/abstract_wallpaper_provider.dart';
import 'package:wallpaper/repository/df_wallpaper_repository.dart';

class DungeonAndFighterWallpaperProvider extends AbstractWallpaperProvider {
  DungeonAndFighterWallpaperProvider() : super(DungeonAndFighterWallpaperRepository());
}
