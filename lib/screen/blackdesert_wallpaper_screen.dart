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
    with WallpaperMixin {

  @override
  Widget build(BuildContext context) {
    return Consumer<BlackDesertWallpaperProvider>(
      builder: (context, blackDesertProvider, child) {
        final isLoading = blackDesertProvider.isLoading;
        final error = blackDesertProvider.error;
        final currentPage = blackDesertProvider.currentPageIndex;
        final wallpapers = blackDesertProvider.wallpaperPage.wallpapers;
        final pageNumbers = List.generate(
            blackDesertProvider.wallpaperPage.pageUrls.length,
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
                    var url =
                    Theme.of(context).platform == TargetPlatform.android ||
                        Theme.of(context).platform == TargetPlatform.iOS
                        ? wallpaper['attr-img_m']
                        : wallpaper['attr-img'];
                    //모바일이 지원 안되는 월페이퍼 구분
                    if (!url!.startsWith('http')) {
                      url = wallpaper['src'];
                    }
                    return buildWallpaperCard(url!,
                        isMobileUnSupported: url == wallpaper['src']);
                  },
                  controller: scrollController,
                ),
              ),
              buildPageNumbers(pageNumbers, currentPage, blackDesertProvider),
            ],
          ),
        );
      },
    );
  }
}