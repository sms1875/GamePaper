import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/provider/df_wallpaper_provider.dart';
import 'package:wallpaper/screen/wallpaper_screen.dart';

class DungeonAndFighterWallpaperScreen extends StatefulWidget {
  @override
  State<DungeonAndFighterWallpaperScreen> createState() =>
      _DungeonAndFighterWallpaperScreenState();
}

class _DungeonAndFighterWallpaperScreenState
    extends State<DungeonAndFighterWallpaperScreen> with WallpaperScreen {
  @override
  Widget build(BuildContext context) {
    return Consumer<DungeonAndFighterWallpaperProvider>(
      builder: (context, dungeonAndFighterProvider, child) {
        final currentPage = dungeonAndFighterProvider.currentPageIndex;
        final wallpapers = dungeonAndFighterProvider.wallpaperPage.wallpapers;
        final pageNumbers = List.generate(
            dungeonAndFighterProvider.wallpaperPage.pageUrlsList.length,
            (index) => index + 1);
        return buildWallpaperWidget(currentPage, wallpapers, pageNumbers);
      },
    );
  }
}
