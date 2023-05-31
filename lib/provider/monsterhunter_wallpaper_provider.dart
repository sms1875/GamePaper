import 'package:wallpaper/provider/abstract_wallpaper_provider.dart';
import 'package:wallpaper/repository/monsterhunter_wallpaper_repository.dart';

class MonsterHunterWallpaperProvider extends AbstractWallpaperProvider {
  MonsterHunterWallpaperProvider() : super(MonsterHunterWallpaperRepository());
}
