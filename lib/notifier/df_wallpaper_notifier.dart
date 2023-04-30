import 'package:flutter/material.dart';
import 'package:wallpaper/data/df_wallpaper.dart';
import 'package:wallpaper/repository/df_wallpaper_repository.dart';

class DungeonAndFighterWallpaperNotifier extends ChangeNotifier {
  DungeonAndFighterWallpaperNotifier();

  DungeonAndFighterWallpaper paging = DungeonAndFighterWallpaper(page: 1, pageUrls: [], wallpapers: []);
  DungeonAndFighterWallpaper get imageList => paging;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error => _error;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  //초기 설정
  Future<void> update(DungeonAndFighterWallpaperRepository repository) async {
    try {
      paging = (await repository.fetchDungeonAndFighterWallpaper());
      _isLoading = false;
      _error = null;
    } catch (e) {
      paging = DungeonAndFighterWallpaper(page: 1, pageUrls: [], wallpapers: []);
      _isLoading = false;
      _error = e;
    }
    notifyListeners();
  }

  //페이지 업데이트
  Future<void> fetchImageListPage(DungeonAndFighterWallpaperRepository repository, int page) async {
    _currentPage=page;

    try {
      final result = await repository.fetchPage(page, imageList.pageUrls);
      paging = DungeonAndFighterWallpaper(page: page, pageUrls: imageList.pageUrls, wallpapers: result);
      _isLoading = false;
      _error = null;
    } catch (e) {
      paging = DungeonAndFighterWallpaper(page: page, pageUrls: [], wallpapers: []);
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
