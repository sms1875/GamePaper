import 'package:flutter/material.dart';
import 'package:wallpaper/widgets/wallpaper_grid.dart';
import 'package:wallpaper/widgets/page_navigation.dart';
import 'package:wallpaper/widgets/error_display.dart';
import 'package:wallpaper/providers/abstract_wallpaper_provider.dart';

class WallpaperScreen extends StatefulWidget {
  final WallpaperProvider wallpaperProvider;

  const WallpaperScreen({Key? key, required this.wallpaperProvider}) : super(key: key);

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  late WallpaperProvider _wallpaperProvider;
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
              wallpapers: _wallpaperProvider.wallpaperPage.wallpapers,
              scrollController: _scrollController,
            ),
          ),
          PageNavigation(
            currentPage: _wallpaperProvider.currentPageIndex,
            pageNumbers: _wallpaperProvider.pageNumbers,
            onPageChanged: _onPageChanged,
          ),
        ],
      ),
    );
  }

  Future<void> _onPageChanged(int page) async {
    if (!_wallpaperProvider.isLoading) {
      await _wallpaperProvider.getPage(page);
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }
}