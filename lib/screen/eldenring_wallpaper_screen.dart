import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/provider/apexlegends_wallpaper_provider.dart';
import 'package:wallpaper/provider/eldenring_wallpaper_provider.dart';
import 'package:wallpaper/screen/wallpaper_screen.dart';

class EldenringWallpaperScreen extends StatefulWidget {
  @override
  State<EldenringWallpaperScreen> createState() =>
      _EldenringWallpaperScreenState();
}

class _EldenringWallpaperScreenState extends State<EldenringWallpaperScreen> with WallpaperMixin {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<EldenRingWallpaperProvider>(context, listen: false).update();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EldenRingWallpaperProvider>(
      builder: (context, eldenRingProvider, child) {
        final isLoading = eldenRingProvider.isLoading;
        final error = eldenRingProvider.error;
        final currentPage = eldenRingProvider.currentPageIndex;
        final pageNumbers = eldenRingProvider.pageNumbers;
        final wallpapers = eldenRingProvider.wallpaperPage.wallpapers;
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
                    itemCount: eldenRingProvider.wallpaperPage.wallpapers.length,
                    itemBuilder: (context, index) {
                      final wallpaper = wallpapers[index];
                      final url = wallpaper['src']!;
                      return buildWallpaperCard(url);
                    },
                    controller: scrollController
                ),
              ),
              buildPageNumbers(pageNumbers, currentPage, eldenRingProvider)
            ],
          ),
        );
      },
    );
  }
}