import 'package:flutter/material.dart';
import 'package:wallpaper/data/wallpaper.dart';
import 'package:wallpaper/repository/blackdesert_wallpaper_repository.dart';

class BlackDesertWallpaperNotifier extends ChangeNotifier {
  BlackDesertWallpaperNotifier();

  Wallpaper _wallpaperPage = Wallpaper(page: 1, pageUrls: [], wallpapers: []);
  Wallpaper get wallpaperPage => _wallpaperPage;

  bool _isWallpaperPageLoading = true;
  bool get isWallpaperPageLoading => _isWallpaperPageLoading;

  Object? _wallpaperPageError;
  Object? get wallpaperPageError => _wallpaperPageError;

  int currentPageIndex = 1;

  Future<void> update(BlackDesertWallpaperRepository repository) async {
    try {
      _wallpaperPage = (await repository.fetchBlackDesertWallpaper(1));
      _isWallpaperPageLoading = false;
      _wallpaperPageError = null;
    } catch (e) {
      _wallpaperPage = Wallpaper(page: 1, pageUrls: [], wallpapers: []);
      _isWallpaperPageLoading = false;
      _wallpaperPageError = e;
    }
    notifyListeners();
  }

  Future<void> fetchImageListPage(
      BlackDesertWallpaperRepository repository, int page) async {
    currentPageIndex = page;

    // 현재 페이지의 pageUrls 값만 가져와서 업데이트합니다
    final result = await repository.fetchBlackDesertWallpaper(page)
        .catchError((e) => repository.fetchBlackDesertWallpaperOnError(page))
        .catchError((e) => Wallpaper(page: page, pageUrls: [], wallpapers: []));
    _wallpaperPage = Wallpaper(
        page: result.page,
        pageUrls: wallpaperPage.pageUrls,
        wallpapers: result.wallpapers);
    _isWallpaperPageLoading = false;
    _wallpaperPageError = result is Wallpaper ? null : result;
    notifyListeners();
  }

  void nextPage(BlackDesertWallpaperRepository repository) {
    final nextPage = wallpaperPage.page + 1;
    if (nextPage <= wallpaperPage.pageUrls.length) {
      fetchImageListPage(repository, nextPage);
    }
  }

  void prevPage(BlackDesertWallpaperRepository repository) {
    final prevPage = wallpaperPage.page - 1;
    if (prevPage > 0) {
      fetchImageListPage(repository, prevPage);
    }
  }
}
