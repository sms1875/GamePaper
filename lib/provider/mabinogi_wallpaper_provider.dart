import 'package:wallpaper/provider/abstract_wallpaper_provider.dart';
import 'package:wallpaper/repository/mabinogi_wallpaper_repository.dart';

class MabinogiWallpaperProvider extends AbstractWallpaperProvider {
  MabinogiWallpaperProvider() : super(MabinogiWallpaperRepository());
}
