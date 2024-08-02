import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallpaper/widgets/wallpaper_grid.dart';
import 'package:wallpaper/widgets/error_display.dart';
import 'package:wallpaper/providers/abstract_wallpaper_provider.dart';

/// WallpaperScreen 클래스는 배경화면을 보여주는 화면입니다.
/// wallpaperProvider를 통해 데이터를 불러오고, PageView와 SmoothPageIndicator를 사용하여 페이지를 전환합니다.
class WallpaperScreen extends StatefulWidget {
  final AbstractWallpaperProvider wallpaperProvider;

  const WallpaperScreen({Key? key, required this.wallpaperProvider}) : super(key: key);

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  late AbstractWallpaperProvider _wallpaperProvider;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _wallpaperProvider = widget.wallpaperProvider;
    _wallpaperProvider.addListener(_updateState);
    _wallpaperProvider.update();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _wallpaperProvider.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  /// 화면의 본문을 빌드합니다.
  Widget _buildBody() {
    if (_wallpaperProvider.error != null) {
      return ErrorDisplay(onRetry: _wallpaperProvider.update);
    }

    if (_wallpaperProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_wallpaperProvider.wallpaperPage.wallpapersByPage.isEmpty) {
      return const Center(
        child: Text('No wallpapers available', style: TextStyle(color: Colors.white)),
      );
    }

    return Column(
      children: [
        _buildPageView(),
        _buildSmoothPageIndicator(),
      ],
    );
  }

  /// PageView를 빌드하여 페이지별로 배경화면을 보여줍니다.
  Widget _buildPageView() {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        itemCount: _wallpaperProvider.wallpaperPage.wallpapersByPage.length,
        itemBuilder: (context, index) {
          return WallpaperGrid(
            wallpapers: _wallpaperProvider.wallpaperPage.wallpapersByPage[index],
          );
        },
        onPageChanged: (index) {
          _wallpaperProvider.currentPageIndex = index;
        },
      ),
    );
  }

  /// SmoothPageIndicator를 빌드하여 페이지 인디케이터를 표시합니다.
  Widget _buildSmoothPageIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SmoothPageIndicator(
        controller: _pageController,
        count: _wallpaperProvider.wallpaperPage.wallpapersByPage.length,
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
