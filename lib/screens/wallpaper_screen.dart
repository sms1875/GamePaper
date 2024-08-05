import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallpaper/models/wallpaper.dart';
import 'package:wallpaper/widgets/wallpaper_grid.dart';
import 'package:wallpaper/models/game.dart';

class WallpaperScreen extends StatefulWidget {
  final Game game;

  const WallpaperScreen({Key? key, required this.game}) : super(key: key);

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final PageController _pageController = PageController();
  late Future<Wallpaper> _wallpaperFuture;

  @override
  void initState() {
    super.initState();
    _wallpaperFuture = widget.game.wallpaper;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<Wallpaper>(
          future: _wallpaperFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.wallpapersByPage.isEmpty) {
              return const Center(child: Text('No wallpapers available'));
            }

            final wallpaper = snapshot.data!;
            return Column(
              children: [
                _buildPageView(wallpaper),
                _buildSmoothPageIndicator(wallpaper.pageNumbers.length),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageView(Wallpaper wallpaper) {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        itemCount: wallpaper.pageNumbers.length,
        itemBuilder: (context, index) {
          return WallpaperGrid(wallpapers: wallpaper.wallpapersByPage[index]);
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
        effect: const WormEffect(
          dotColor: Colors.grey,
          activeDotColor: Colors.blue,
          dotHeight: 8.0,
          dotWidth: 8.0,
        ),
      ),
    );
  }
}