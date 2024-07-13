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

import 'package:wallpaper/models/game.dart';

List<Game> gameList = [
  Game(
    title: 'Black Desert',
    image: 'assets/images/blackdesert.png',
    repository: BlackDesertWallpaperRepository(),
  ),
  Game(
    title: 'Dungeon & Fighter',
    image: 'assets/images/dungeon&fighter.png',
    repository: DungeonAndFighterWallpaperRepository(),
  ),
  Game(
    title: 'Apex Legends',
    image: 'assets/images/apexlegends.webp',
    repository: ApexLegendsWallpaperRepository(),
  ),
  Game(
    title: 'Ambrogino',
    image: 'assets/images/mabinogi.png',
    repository: MabinogiWallpaperRepository(),
  ),
  Game(
    title: 'Elden Ring',
    image: 'assets/images/eldenring.png',
    repository: EldenRingWallpaperRepository(),
  ),
  Game(
    title: 'Monster Hunter',
    image: 'assets/images/monster_hunter.webp',
    repository: MonsterHunterWallpaperRepository(),
  ),
  Game(
    title: 'Final Fantasy XIV',
    image: 'assets/images/finalfantasy14.png',
    repository: FinalFantasy14WallpaperRepository(),
  ),
  Game(
    title: 'Maple Story 2',
    image: 'assets/images/maplestory2.png',
    repository: MapleStory2WallpaperRepository(),
  ),
  Game(
    title: 'Elder Scrolls Online',
    image: 'assets/images/elderscrollsonline.png',
    repository: ElderScrollsOnlineWallpaperRepository(),
  ),
  Game(
    title: 'World of Tanks',
    image: 'assets/images/worldoftanks.webp',
    repository: WorldOfTanksWallpaperRepository(),
  ),
  Game(
    title: 'Heaven Burns Red',
    image: 'assets/images/heavenburnsred.png',
    repository: HeavenBurnsRedWallpaperRepository(),
  ),
  Game(
    title: 'Princess Connect Re:Dive',
    image: 'assets/images/priconne.png',
    repository: PriConneWallpaperRepository(),
  ),
];