import 'package:wallpaper/provider/apexlegends_wallpaper_provider.dart';
import 'package:wallpaper/provider/blackdesert_wallpaper_provider.dart';
import 'package:wallpaper/provider/df_wallpaper_provider.dart';
import 'package:wallpaper/provider/eldenring_wallpaper_provider.dart';
import 'package:wallpaper/provider/elderscrollsonline_wallpaper_provider.dart';
import 'package:wallpaper/provider/finalfantasy14_wallpaper_provider.dart';
import 'package:wallpaper/provider/heavenburnsred_wallpaper_provider.dart';
import 'package:wallpaper/provider/mabinogi_wallpaper_provider.dart';
import 'package:wallpaper/provider/maplestory2_wallpaper_provider.dart';
import 'package:wallpaper/provider/monsterhunter_wallpaper_provider.dart';
import 'package:wallpaper/provider/priconne_wallpaper_provider.dart';
import 'package:wallpaper/provider/worldofthanks_wallpaper_provider.dart';

final List<Map<String, dynamic>> gameList = [
  {
    'title': 'Black Desert',
    'image': 'assets/images/blackdesert.png',
    'provider': BlackDesertWallpaperProvider(),
  },
  {
    'title': 'Dungeon & Fighter',
    'image': 'assets/images/dungeon&fighter.png',
    'provider': DungeonAndFighterWallpaperProvider(),
  },
  {
    'title': 'Apex Legends',
    'image': 'assets/images/apexlegends.webp',
    'provider': ApexLegendsWallpaperProvider(),
  },
  {
    'title': 'Mabinogi',
    'image': 'assets/images/mabinogi.png',
    'provider': MabinogiWallpaperProvider(),
  },
  {
    'title': 'Elden Ring',
    'image': 'assets/images/eldenring.png',
    'provider': EldenRingWallpaperProvider(),
  },
  {
    'title': 'Monster Hunter',
    'image': 'assets/images/monster_hunter.webp',
    'provider': MonsterHunterWallpaperProvider(),
  },
  {
    'title': 'Final Fantasy XIV',
    'image': 'assets/images/finalfantasy14.png',
    'provider': FinalFantasy14WallpaperProvider(),
  },
  {
    'title': 'Maple Story 2',
    'image': 'assets/images/maplestory2.png',
    'provider': MapleStory2WallpaperProvider(),
  },
  {
    'title': 'Elder Scrolls Online',
    'image': 'assets/images/elderscrollsonline.png',
    'provider': ElderScrollsOnlineWallpaperProvider(),
  },
  {
    'title': 'World of Tanks',
    'image': 'assets/images/worldoftanks.webp',
    'provider': WorldOfTanksWallpaperProvider(),
  },
  {
    'title': 'Heaven Burns Red',
    'image': 'assets/images/heavenburnsred.png',
    'provider': HeavenBurnsRedWallpaperProvider(),
  },
  {
    'title': 'Princess Connect Re:Dive',
    'image': 'assets/images/priconne.png',
    'provider': PriConneWallpaperProvider(),
  },
];