import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/data/ImageList.dart';
import 'package:wallpaper/repository/wallpaper_repository.dart';

class WallpaperNotifier extends ChangeNotifier {
  WallpaperNotifier();


  ImageListPage paging = ImageListPage(page: 1, pageUrls: [], wallpapers: []);
  ImageListPage get imageList => paging;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error => _error;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  Future<void> update(WallpaperRepository repository) async {
    try {
      paging = (await repository.fetchImageListPage(1));
      _isLoading = false;
      _error = null;
    } catch (e) {
      paging = ImageListPage(page: 1, pageUrls: [], wallpapers: []);
      _isLoading = false;
      _error = e;
    }
    notifyListeners();
  }

  Future<void> fetchImageListPage(WallpaperRepository repository, int page) async {
    _currentPage=page;

    try {
      final result = await repository.fetchImageListPage(page);
      // 현재 페이지의 pageUrls 값만 가져와서 업데이트합니다
      paging = ImageListPage(page: result.page, pageUrls: imageList.pageUrls, wallpapers: result.wallpapers);
      _isLoading = false;
      _error = null;
    } catch (e) {
      print(e);
      final result = await repository.fetchImageListPage2(page);
      paging = ImageListPage(page: result.page, pageUrls: imageList.pageUrls, wallpapers: result.wallpapers);
      _isLoading = false;
      _error = e;
    }
    notifyListeners();
  }

  void nextPage(WallpaperRepository repository) {
    if (currentPage < imageList.pageUrls.length) {
      fetchImageListPage(repository, currentPage + 1);
    }
  }

  void prevPage(WallpaperRepository repository) {
    if (currentPage > 0) {
      fetchImageListPage(repository, currentPage - 1);
    }
  }
}
