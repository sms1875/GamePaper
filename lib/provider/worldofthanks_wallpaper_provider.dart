import 'package:wallpaper/provider/abstract_wallpaper_provider.dart';
import 'package:wallpaper/repository/worldoftanks_wallpaper_repository.dart';

class WorldOfTanksWallpaperProvider extends AbstractWallpaperProvider {
  WorldOfTanksWallpaperProvider() : super(WorldOfTanksWallpaperRepository());
}
