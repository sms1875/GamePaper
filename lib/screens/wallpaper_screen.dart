import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallpaper/widgets/wallpaper_grid.dart';
import 'package:wallpaper/models/game.dart';

/// WallpaperScreen 위젯
///
/// 선택한 게임의 월페이퍼 목록을 페이지 단위로 표시합니다.
class WallpaperScreen extends StatefulWidget {
  final Game game;

  const WallpaperScreen({Key? key, required this.game}) : super(key: key);

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final PageController _pageController = PageController();
  late Future<int> _totalWallpapersFuture;
  final int wallpapersPerPage = 12;

  @override
  void initState() {
    super.initState();
    _totalWallpapersFuture = widget.game.totalWallpapers;
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
        child: FutureBuilder<int>(
          future: _totalWallpapersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == 0) {
              return const Center(child: Text('No wallpapers available'));
            }

            final totalWallpapers = snapshot.data!;
            final pageCount = (totalWallpapers / wallpapersPerPage).ceil();

            return Column(
              children: [
                _buildPageView(pageCount),
                _buildSmoothPageIndicator(pageCount),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 페이지 뷰 빌드 메서드
  Widget _buildPageView(int pageCount) {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        itemCount: pageCount,
        itemBuilder: (context, index) {
          return FutureBuilder<List<String>>(
            future: widget.game.getWallpapersForPage(index + 1, wallpapersPerPage),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No wallpapers for this page'));
              }

              return WallpaperGrid(wallpapers: snapshot.data!);
            },
          );
        },
      ),
    );
  }

  /// 페이지 인디케이터 빌드 메서드
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