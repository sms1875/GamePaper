import 'package:flutter/material.dart';
import 'package:wallpaper/widgets/wallpaper_grid.dart';
import 'package:wallpaper/widgets/page_navigation.dart';
import 'package:wallpaper/widgets/error_display.dart';
import 'package:wallpaper/providers/abstract_wallpaper_provider.dart';

/// `WallpaperScreen`은 배경화면을 표시하는 화면입니다.
///
/// 배경화면 제공자와의 통신을 관리하고, 오류가 발생한 경우 오류 화면을 표시하며,
/// 정상적으로 배경화면을 불러왔을 경우 배경화면 그리드와 페이지 네비게이션을 표시합니다.
class WallpaperScreen extends StatefulWidget {
  final AbstractWallpaperProvider wallpaperProvider;

  const WallpaperScreen({Key? key, required this.wallpaperProvider}) : super(key: key);

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  late AbstractWallpaperProvider _wallpaperProvider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _wallpaperProvider = widget.wallpaperProvider;
    _wallpaperProvider.addListener(_updateState);
    _wallpaperProvider.update();
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
      body: _wallpaperProvider.error != null
          ? ErrorDisplay(onRetry: _wallpaperProvider.update)
          : Column(
        children: [
          Expanded(
            child: WallpaperGrid(
              wallpapers: _wallpaperProvider.wallpaperPage.wallpapersByPage.isNotEmpty
                  ? _wallpaperProvider.wallpaperPage.wallpapersByPage[_wallpaperProvider.currentPageIndex]
                  : [],
              scrollController: _scrollController,
            ),
          ),
          PageNavigation(
            currentPage: _wallpaperProvider.currentPageIndex + 1,
            pageNumbers: List.generate(
                _wallpaperProvider.wallpaperPage.wallpapersByPage.length, (index) => index + 1),
            onPageChanged: _onPageChanged,
          ),
        ],
      ),
    );
  }

  /// 페이지 변경 시 호출되는 메서드입니다.
  ///
  /// 현재 페이지를 업데이트하고, 스크롤 위치를 최상단으로 이동시킵니다.
  void _onPageChanged(int page) {
    if (!_wallpaperProvider.isLoading) {
      _wallpaperProvider.currentPageIndex = page - 1;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {});
    }
  }
}
