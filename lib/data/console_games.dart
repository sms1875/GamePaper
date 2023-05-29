import 'package:wallpaper/screen/eldenring_wallpaper_screen.dart';
import 'package:wallpaper/screen/monsterhunter_wallpaper_screen.dart';

final List<Map<String, dynamic>> consoleGames = [
  {
    'title': 'Elden Ring',
    'image': 'assets/images/eldenring.jpg',
    'page': EldenringWallpaperScreen(),
  },
  {
    'title': 'Monster Hunter',
    'image': 'assets/images/monster_hunter.webp',
    'page': MonsterHunterWallpaperScreen(),
  },
];