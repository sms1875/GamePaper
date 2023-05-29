import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/repository/monsterhunter_wallpaper_repository.dart';

class MonsterHunterWallpaperProvider extends WallpaperProvider {
  MonsterHunterWallpaperProvider() : super(MonsterHunterWallpaperRepository());
}
