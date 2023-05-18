import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/provider/apexlegends_wallpaper_provider.dart';
import 'package:wallpaper/screen/wallpaper_screen.dart';

class ApexLegendsWallpaperScreen extends StatefulWidget {
  @override
  State<ApexLegendsWallpaperScreen> createState() =>
      _ApexLegendsWallpaperScreenState();
}

class _ApexLegendsWallpaperScreenState extends State<ApexLegendsWallpaperScreen> with WallpaperMixin {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<ApexLegendsWallpaperProvider>(context, listen: false).update();
  }

  @override
  Widget build(BuildContext context) {
    final apexLegendsProvider = Provider.of<ApexLegendsWallpaperProvider>(context);
    final isLoading = apexLegendsProvider.isLoading;
    final error = apexLegendsProvider.error;
    final currentPage = apexLegendsProvider.currentPageIndex;
    final pageNumbers = apexLegendsProvider.pageNumbers;
    final wallpapers = apexLegendsProvider.wallpaperPage.wallpapers;

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
              controller: scrollController,
            ),
          ),
          buildPageNumbers(pageNumbers, currentPage, apexLegendsProvider),
        ],
      ),
    );
  }

}