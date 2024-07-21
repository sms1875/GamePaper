import 'package:flutter/material.dart';
import 'package:wallpaper/widgets/wallpaper_grid.dart';
import 'package:wallpaper/widgets/page_navigation.dart';
import 'package:wallpaper/widgets/error_display.dart';
import 'package:wallpaper/providers/abstract_wallpaper_provider.dart';

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
          ? ErrorDisplay(
        onRetry: _wallpaperProvider.update,
      )
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
            pageNumbers: List.generate(_wallpaperProvider.wallpaperPage.wallpapersByPage.length, (index) => index + 1),
            onPageChanged: _onPageChanged,
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int page) {
    if (!_wallpaperProvider.isLoading) {
      _wallpaperProvider.currentPageIndex = page - 1;
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() {});
    }
  }
}