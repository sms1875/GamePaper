import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/provider/blackdesert_wallpaper_provider.dart';
import 'package:wallpaper/screen/wallpaper_screen.dart';

class BlackDesertWallpaperScreen extends StatefulWidget {
  @override
  State<BlackDesertWallpaperScreen> createState() =>
      _BlackDesertWallpaperScreenState();
}

class _BlackDesertWallpaperScreenState extends State<BlackDesertWallpaperScreen>
    with WallpaperScreen {
  @override
  Widget build(BuildContext context) {
    return Consumer<BlackDesertWallpaperProvider>(
      builder: (context, blackDesertProvider, child) {
        final currentPage = blackDesertProvider.currentPageIndex;
        final wallpapers = blackDesertProvider.wallpaperPage.wallpapers;
        final pageNumbers = List.generate(
            blackDesertProvider.wallpaperPage.pageUrls.length,
            (index) => index + 1);
        return buildWallpaperWidget(currentPage, wallpapers, pageNumbers);
      },
    );
  }
}
