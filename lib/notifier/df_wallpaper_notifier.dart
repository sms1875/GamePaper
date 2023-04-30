import 'package:flutter/material.dart';
import 'package:wallpaper/data/wallpaper.dart';
import 'package:wallpaper/repository/df_wallpaper_repository.dart';

class DungeonAndFighterWallpaperNotifier extends ChangeNotifier {
  DungeonAndFighterWallpaperNotifier();

  Wallpaper paging = Wallpaper(page: 1, pageUrls: [], wallpapers: []);
  Wallpaper get imageList => paging;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error => _error;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  Future<void> update(DungeonAndFighterWallpaperRepository repository) async {
    try {
      paging = (await repository.fetchDungeonAndFighterWallpaper(1));
      _isLoading = false;
      _error = null;
    } catch (e) {
      paging = Wallpaper(page: 1, pageUrls: [], wallpapers: []);
      _isLoading = false;
      _error = e;
    }
    notifyListeners();
  }

  Future<void> fetchImageListPage(DungeonAndFighterWallpaperRepository repository, int page) async {
    _currentPage=page;

    // 현재 페이지의 pageUrls 값만 가져와서 업데이트합니다
    try {
      final result = await repository.fetchDungeonAndFighterWallpaper(page);
      paging = Wallpaper(page: result.page, pageUrls: imageList.pageUrls, wallpapers: result.wallpapers);
      _isLoading = false;
      _error = null;
    } catch (e) {
      paging = Wallpaper(page: 1, pageUrls: [], wallpapers: []);
      _isLoading = false;
      _error = e;
    }
    notifyListeners();
  }

  void nextPage(DungeonAndFighterWallpaperRepository repository) {
    if (currentPage < imageList.pageUrls.length) {
      fetchImageListPage(repository, currentPage + 1);
    }
  }

  void prevPage(DungeonAndFighterWallpaperRepository repository) {
    if (currentPage > 0) {
      fetchImageListPage(repository, currentPage - 1);
    }
  }
}
