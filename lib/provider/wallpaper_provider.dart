import 'package:flutter/material.dart';
import 'package:wallpaper/data/wallpaper.dart';

abstract class WallpaperProvider extends ChangeNotifier {
  Wallpaper _wallpaperPage = Wallpaper(page: 1, pageUrlsList: [], wallpapers: []);
  Wallpaper get wallpaperPage => _wallpaperPage;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error {
    final error=_error;
    _error= null;
    return error;
  }

  List<int> pageNumbers = [];
  int currentPageIndex = 1;

  Future<void> update() async {}

  Future<void> fetchPage(int page) async {
    currentPageIndex = page;
  }

  void nextPage() {
    final nextPage = wallpaperPage.page + 1;
    if (nextPage <= wallpaperPage.pageUrlsList.length) {
      fetchPage(nextPage);
    }
  }

  void prevPage() {
    final prevPage = wallpaperPage.page - 1;
    if (prevPage > 0) {
      fetchPage(prevPage);
    }
  }

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
  }

  void setError(Object error) {
    print(error);
    _error = error;
  }
}
