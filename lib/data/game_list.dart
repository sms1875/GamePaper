import 'package:wallpaper/repository/apexlegends_wallpaper_repository.dart';
import 'package:wallpaper/repository/blackdesert_wallpaper_repository.dart';
import 'package:wallpaper/repository/df_wallpaper_repository.dart';
import 'package:wallpaper/repository/eldenring_wallpaper_repository.dart';
import 'package:wallpaper/repository/elderscrollsonline_wallpaper_repository.dart';
import 'package:wallpaper/repository/finalfantasy14_wallpaper_repository.dart';
import 'package:wallpaper/repository/heavenburnsred_wallpaper_repository.dart';
import 'package:wallpaper/repository/mabinogi_wallpaper_repository.dart';
import 'package:wallpaper/repository/maplestory2_wallpaper_repository.dart';
import 'package:wallpaper/repository/monsterhunter_wallpaper_repository.dart';
import 'package:wallpaper/repository/priconne_wallpaper_repository.dart';
import 'package:wallpaper/repository/worldoftanks_wallpaper_repository.dart';

final List<Map<String, dynamic>> gameList = [
  {
    'title': 'Black Desert',
    'image': 'assets/images/blackdesert.png',
    'repository': BlackDesertWallpaperRepository(),
  },
  {
    'title': 'Dungeon & Fighter',
    'image': 'assets/images/dungeon&fighter.png',
    'repository': DungeonAndFighterWallpaperRepository(),
  },
  {
    'title': 'Apex Legends',
    'image': 'assets/images/apexlegends.webp',
    'repository': ApexLegendsWallpaperRepository(),
  },
  {
    'title': 'Mabinogi',
    'image': 'assets/images/mabinogi.png',
    'repository': MabinogiWallpaperRepository(),
  },
  {
    'title': 'Elden Ring',
    'image': 'assets/images/eldenring.png',
    'repository': EldenRingWallpaperRepository(),
  },
  {
    'title': 'Monster Hunter',
    'image': 'assets/images/monster_hunter.webp',
    'repository': MonsterHunterWallpaperRepository(),
  },
  {
    'title': 'Final Fantasy XIV',
    'image': 'assets/images/finalfantasy14.png',
    'repository': FinalFantasy14WallpaperRepository(),
  },
  {
    'title': 'Maple Story 2',
    'image': 'assets/images/maplestory2.png',
    'repository': MapleStory2WallpaperRepository(),
  },
  {
    'title': 'Elder Scrolls Online',
    'image': 'assets/images/elderscrollsonline.png',
    'repository': ElderScrollsOnlineWallpaperRepository(),
  },
  {
    'title': 'World of Tanks',
    'image': 'assets/images/worldoftanks.webp',
    'repository': WorldOfTanksWallpaperRepository(),
  },
  {
    'title': 'Heaven Burns Red',
    'image': 'assets/images/heavenburnsred.png',
    'repository': HeavenBurnsRedWallpaperRepository(),
  },
  {
    'title': 'Princess Connect Re:Dive',
    'image': 'assets/images/priconne.png',
    'repository': PriConneWallpaperRepository(),
  },
];