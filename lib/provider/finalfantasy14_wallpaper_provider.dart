import 'package:wallpaper/provider/abstract_wallpaper_provider.dart';
import 'package:wallpaper/repository/finalfantasy14_wallpaper_repository.dart';

class FinalFantasy14WallpaperProvider extends AbstractWallpaperProvider {
  FinalFantasy14WallpaperProvider() : super(FinalFantasy14WallpaperRepository());
}
