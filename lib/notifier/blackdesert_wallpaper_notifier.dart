import 'package:flutter/material.dart';
import 'package:wallpaper/data/wallpaper.dart';
import 'package:wallpaper/repository/blackdesert_wallpaper_repository.dart';

class BlackDesertWallpaperNotifier extends ChangeNotifier {
  final BlackDesertWallpaperRepository _blackDesertWallpaperRepository =
  BlackDesertWallpaperRepository();

  Wallpaper _wallpaperPage = Wallpaper(page: 1, pageUrls: [], wallpapers: []);

  Wallpaper get wallpaperPage => _wallpaperPage;

  bool _isWallpaperPageLoading = true;

  bool get isWallpaperPageLoading => _isWallpaperPageLoading;

  Object? _wallpaperPageError;

  Object? get wallpaperPageError => _wallpaperPageError;

  int currentPageIndex = 1;

  Future<void> update() async {
    try {
      _wallpaperPage =
      (await _blackDesertWallpaperRepository.fetchBlackDesertWallpaper());
      _isWallpaperPageLoading = false;
      _wallpaperPageError = null;
    } catch (e) {
      _wallpaperPage = Wallpaper(page: 1, pageUrls: [], wallpapers: []);
      _isWallpaperPageLoading = false;
      _wallpaperPageError = e;
    }
    notifyListeners();
  }

  Future<void> fetchImageListPage(int page) async {
    currentPageIndex = page;

    final result = await _blackDesertWallpaperRepository
        .fetchpage(page, wallpaperPage.pageUrls)
        .catchError((e) => _blackDesertWallpaperRepository.fetchpageOnError(page))
        .catchError((e) => e);
    _wallpaperPage = Wallpaper(
        page: page,
        pageUrls: wallpaperPage.pageUrls,
        wallpapers: result);
    _isWallpaperPageLoading = false;
    _wallpaperPageError = result is Wallpaper ? null : result;
    notifyListeners();
  }

  void nextPage() {
    final nextPage = wallpaperPage.page + 1;
    if (nextPage <= wallpaperPage.pageUrls.length) {
      fetchImageListPage(nextPage);
    }
  }

  void prevPage() {
    final prevPage = wallpaperPage.page - 1;
    if (prevPage > 0) {
      fetchImageListPage(prevPage);
    }
  }
}
