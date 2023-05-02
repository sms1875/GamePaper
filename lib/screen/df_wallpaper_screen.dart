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
    extends State<DungeonAndFighterWallpaperScreen> with WallpaperMixin {

  @override
  Widget build(BuildContext context) {
    return Consumer<DungeonAndFighterWallpaperProvider>(
      builder: (context, dungeonAndFighterProvider, child) {
        final isLoading = dungeonAndFighterProvider.isLoading;
        final error = dungeonAndFighterProvider.error;
        final currentPage = dungeonAndFighterProvider.currentPageIndex;
        final wallpapers = dungeonAndFighterProvider.wallpaperPage.wallpapers;
        final pageNumbers = List.generate(
            dungeonAndFighterProvider.wallpaperPage.pageUrlsList.length,
                (index) => index + 1);
        return Scaffold(
          body: error != null
              ? buildErrorScreen()
              : Column(
            children: [
              Expanded(
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 9 / 16,
                    ),
                    itemCount: wallpapers.length,
                    itemBuilder: (context, index) {
                      final wallpaper = wallpapers[index];
                      final url = wallpaper['src']!;
                      return buildWallpaperCard(url);
                    },
                    controller: scrollController),
              ),
              buildPageNumbers(pageNumbers, currentPage, dungeonAndFighterProvider)
            ],
          ),
        );
      },
    );
  }
}