import 'package:flutter/material.dart';
import 'package:gamepaper/widgets/common/error_display.dart';
import 'package:gamepaper/widgets/common/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:gamepaper/models/game.dart';
import 'package:gamepaper/providers/wallpaper_provider.dart';
import 'package:gamepaper/widgets/wallpaper/wallpaper_grid.dart';

class WallpaperScreen extends StatefulWidget {
  final Game game;

  const WallpaperScreen({super.key, required this.game});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WallpaperProvider(game: widget.game),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Consumer<WallpaperProvider>(
            builder: (context, wallpaperProvider, child) {
              return FutureBuilder<int>(
                future: wallpaperProvider.totalWallpapersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: LoadingWidget());
                  } else if (snapshot.hasError) {
                    return ErrorDisplayWidget(
                      error: snapshot.error!,
                      onRetry: () => wallpaperProvider.loadWallpapers(),
                    );
                  } else if (!snapshot.hasData || snapshot.data == 0) {
                    return ErrorDisplayWidget(
                      error: 'no-wallpapers-available',
                      onRetry: () => wallpaperProvider.loadWallpapers(),
                    );
                  }

                  final totalWallpapers = snapshot.data!;
                  final pageCount = (totalWallpapers / wallpaperProvider.wallpapersPerPage).ceil();

                  return Column(
                    children: [
                      _buildPageView(pageCount, wallpaperProvider),
                      _buildSmoothPageIndicator(pageCount),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageView(int pageCount, WallpaperProvider wallpaperProvider) {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        itemCount: pageCount,
        itemBuilder: (context, index) {
          return FutureBuilder<List<Wallpaper>>(
            future: wallpaperProvider.getWallpapersForPage(index + 1),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: LoadingWidget());
              } else if (snapshot.hasError) {
                return ErrorDisplayWidget(
                  error: snapshot.error!,
                  onRetry: () => wallpaperProvider.getWallpapersForPage(index + 1),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return ErrorDisplayWidget(
                  error: 'no-wallpapers-for-this-page',
                  onRetry: () => wallpaperProvider.getWallpapersForPage(index + 1),
                );
              }

              return WallpaperGrid(wallpapers: snapshot.data!);
            },
          );
        },
      ),
    );
  }

  Widget _buildSmoothPageIndicator(int count) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SmoothPageIndicator(
        controller: _pageController,
        count: count,
        effect: const ScrollingDotsEffect(
          dotColor: Colors.grey,
          activeDotColor: Colors.blue,
          dotHeight: 8.0,
          dotWidth: 8.0,
          activeDotScale: 1.5,
          maxVisibleDots: 5,
          spacing: 8.0,
        ),
      ),
    );
  }
}
