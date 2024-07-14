import 'package:wallpaper/repository/apexlegends_wallpaper_repository.dart';
import 'package:wallpaper/repository/blackdesert_wallpaper_repository.dart';
import 'package:wallpaper/repository/eldenring_wallpaper_repository.dart';
import 'package:wallpaper/repository/elderscrollsonline_wallpaper_repository.dart';
import 'package:wallpaper/repository/finalfantasy14_wallpaper_repository.dart';
import 'package:wallpaper/repository/heavenburnsred_wallpaper_repository.dart';
import 'package:wallpaper/repository/mabinogi_wallpaper_repository.dart';
import 'package:wallpaper/repository/maplestory2_wallpaper_repository.dart';
import 'package:wallpaper/repository/priconne_wallpaper_repository.dart';
import 'package:wallpaper/repository/worldoftanks_wallpaper_repository.dart';

import 'package:wallpaper/models/game.dart';

List<Game> gameList = [
  Game(
    title: 'Black Desert',
    image: 'assets/images/blackdesert.png',
    repository: BlackDesertWallpaperRepository('https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/'),
  ),
  Game(
    title: 'Apex Legends',
    image: 'assets/images/apexlegends.webp',
    repository: ApexLegendsWallpaperRepository('https://www.ea.com/ko-kr/games/apex-legends/media#wallpapers'),
  ),
  Game(
    title: 'Mabinogi',
    image: 'assets/images/mabinogi.png',
    repository: MabinogiWallpaperRepository('https://mabinogi.nexon.com/page/pds/gallery_wallpaper.asp'),
  ),
  Game(
    title: 'Elden Ring',
    image: 'assets/images/eldenring.png',
    repository: EldenRingWallpaperRepository('https://eldenring.bn-ent.net/kr/special/'),
  ),
  Game(
    title: 'Final Fantasy XIV',
    image: 'assets/images/finalfantasy14.png',
    repository: FinalFantasy14WallpaperRepository('https://na.finalfantasyxiv.com/lodestone/special/fankit/smartphone_wallpaper/2_0/#nav_fankit'),
  ),
  Game(
    title: 'Maple Story 2',
    image: 'assets/images/maplestory2.png',
    repository: MapleStory2WallpaperRepository('https://maplestory2.nexon.com/Main/SearchNews?tk=배경화면%20다운로드'),
  ),
  Game(
    title: 'Elder Scrolls Online',
    image: 'assets/images/elderscrollsonline.png',
    repository: ElderScrollsOnlineWallpaperRepository('https://www.elderscrollsonline.com/en-gb/media/category/wallpapers/'),
  ),
  Game(
    title: 'World of Tanks',
    image: 'assets/images/worldoftanks.webp',
    repository: WorldOfTanksWallpaperRepository('https://worldoftanks.asia/ko/media/tag/11/'),
  ),
  Game(
    title: 'Heaven Burns Red',
    image: 'assets/images/heavenburnsred.png',
    repository: HeavenBurnsRedWallpaperRepository('https://heaven-burns-red.com/fankit/sp-wallpaper/'),
  ),
  Game(
    title: 'Princess Connect Re:Dive',
    image: 'assets/images/priconne.png',
    repository: PriConneWallpaperRepository('https://priconne-redive.jp/fankit02/'),
  ),
];