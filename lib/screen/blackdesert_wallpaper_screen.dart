import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/provider/blackdesert_wallpaper_provider.dart';
import 'package:wallpaper/screen/wallpaper_screen.dart';

class BlackDesertWallpaperScreen extends StatefulWidget {
  @override
  State<BlackDesertWallpaperScreen> createState() =>
      _BlackDesertWallpaperScreenState();
}

class _BlackDesertWallpaperScreenState extends State<BlackDesertWallpaperScreen> with WallpaperMixin {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<BlackDesertWallpaperProvider>(context, listen: false).update();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BlackDesertWallpaperProvider>(
      builder: (context, blackDesertProvider, child) {
        final isLoading = blackDesertProvider.isLoading;
        final error = blackDesertProvider.error;
        final currentPage = blackDesertProvider.currentPageIndex;
        final pageNumbers = blackDesertProvider.pageNumbers;
        final wallpapers = blackDesertProvider.wallpaperPage.wallpapers;
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
                    controller: scrollController
                ),
              ),
              buildPageNumbers(pageNumbers, currentPage, blackDesertProvider)
            ],
          ),
        );
      },
    );
  }
}