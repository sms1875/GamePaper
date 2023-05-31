import 'package:wallpaper/provider/apexlegends_wallpaper_provider.dart';
import 'package:wallpaper/provider/blackdesert_wallpaper_provider.dart';
import 'package:wallpaper/provider/df_wallpaper_provider.dart';
import 'package:wallpaper/provider/eldenring_wallpaper_provider.dart';
import 'package:wallpaper/provider/finalfantasy14_wallpaper_provider.dart';
import 'package:wallpaper/provider/mabinogi_wallpaper_provider.dart';
import 'package:wallpaper/provider/maplestory2_wallpaper_provider.dart';
import 'package:wallpaper/provider/monsterhunter_wallpaper_provider.dart';
import 'package:wallpaper/screen/apexlegends_wallpaper_screen.dart';
import 'package:wallpaper/screen/blackdesert_wallpaper_screen.dart';
import 'package:wallpaper/screen/df_wallpaper_screen.dart';
import 'package:wallpaper/screen/eldenring_wallpaper_screen.dart';
import 'package:wallpaper/screen/finalfantasy14_wallpaper_screen.dart';
import 'package:wallpaper/screen/mabinogi_wallpaper_screen.dart';
import 'package:wallpaper/screen/maplestory2_wallpaper_screen.dart';
import 'package:wallpaper/screen/monsterhunter_wallpaper_screen.dart';

final List<Map<String, dynamic>> gameList = [
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
  {
    'title': 'Elden Ring',
    'image': 'assets/images/eldenring.png',
    'page': EldenringWallpaperScreen(provider: EldenRingWallpaperProvider()),
  },
  {
    'title': 'Monster Hunter',
    'image': 'assets/images/monster_hunter.webp',
    'page': MonsterHunterWallpaperScreen(provider: MonsterHunterWallpaperProvider()),
  },
  {
    'title': 'Final Fantasy XIV',
    'image': 'assets/images/finalfantasy14.png',
    'page': FinalFantasyWallpaperScreen(provider: FinalFantasy14WallpaperProvider()),
  },
  {
    'title': 'Maple Story 2',
    'image': 'assets/images/maplestory2.png',
    'page': MapleStory2WallpaperScreen(provider: MapleStory2WallpaperProvider()),
  },
];

