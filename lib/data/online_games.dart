import 'package:wallpaper/provider/apexlegends_wallpaper_provider.dart';
import 'package:wallpaper/provider/blackdesert_wallpaper_provider.dart';
import 'package:wallpaper/provider/df_wallpaper_provider.dart';
import 'package:wallpaper/provider/mabinogi_wallpaper_provider.dart';
import 'package:wallpaper/screen/apexlegends_wallpaper_screen.dart';
import 'package:wallpaper/screen/blackdesert_wallpaper_screen.dart';
import 'package:wallpaper/screen/df_wallpaper_screen.dart';
import 'package:wallpaper/screen/mabinogi_wallpaper_screen.dart';

final List<Map<String, dynamic>> onlineGames = [
  {
    'title': 'Black Desert',
    'image': 'assets/images/blackdesert.png',
    'page': BlackDesertWallpaperScreen(provider: BlackDesertWallpaperProvider()),
  },
  {
    'title': 'Dungeon & Fighter',
    'image': 'assets/images/dungeon&fighter.png',
    'page': DungeonAndFighterWallpaperScreen(provider: DungeonAndFighterWallpaperProvider()),
  },
  {
    'title': 'Apex Legends',
    'image': 'assets/images/apexlegends.webp',
    'page': ApexLegendsWallpaperScreen(provider: ApexLegendsWallpaperProvider()),
  },
  {
    'title': 'Mabinogi',
    'image': 'assets/images/mabinogi.png',
    'page': MabinogiWallpaperScreen(provider: MabinogiWallpaperProvider()),
  },
];
