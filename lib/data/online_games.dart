import 'package:wallpaper/screen/apexlegends_wallpaper_screen.dart';
import 'package:wallpaper/screen/blackdesert_wallpaper_screen.dart';
import 'package:wallpaper/screen/df_wallpaper_screen.dart';
import 'package:wallpaper/screen/mabinogi_wallpaper_screen.dart';

final List<Map<String, dynamic>> onlineGames = [
  {
    'title': 'Black Desert',
    'image': 'assets/images/blackdesert.png',
    'page': BlackDesertWallpaperScreen(),
  },
  {
    'title': 'Dungeon & Fighter',
    'image': 'assets/images/dungeon&fighter.png',
    'page': DungeonAndFighterWallpaperScreen(),
  },
  {
    'title': 'Apex Legends',
    'image': 'assets/images/apexlegends.webp',
    'page': ApexLegendsWallpaperScreen(),
  },
  {
    'title': 'Mabinogi',
    'image': 'assets/images/apexlegends.webp',
    'page': MabinogiWallpaperScreen(),
  },
];
