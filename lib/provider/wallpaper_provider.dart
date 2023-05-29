import 'package:flutter/material.dart';
import 'package:wallpaper/data/wallpaper.dart';
import 'package:wallpaper/repository/wallpaper_repository.dart';

abstract class WallpaperProvider extends ChangeNotifier {
  final WallpaperRepository _wallpaperRepository;
  Wallpaper wallpaperPage = Wallpaper(page: 1, pageUrlsList: [], wallpapers: []);

  WallpaperProvider(this._wallpaperRepository);

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

  Future<void> update() async {
    setLoading(true);
    try {
      currentPageIndex = 1;
      wallpaperPage = await _wallpaperRepository.fetchWallpaper();
      pageNumbers = List.generate(wallpaperPage.pageUrlsList.length, (index) => index + 1);
    } catch (e) {
      setError(e);
    }
    notifyListeners();
    setLoading(false);
  }

  Future<void> fetchPage(int page) async {
    setLoading(true);
    currentPageIndex = page;
    try {
      final result = await _wallpaperRepository.fetchPage(
          page, wallpaperPage.pageUrlsList);
      wallpaperPage = Wallpaper(
          page: page,
          pageUrlsList: wallpaperPage.pageUrlsList,
          wallpapers: result);
    } catch (e) {
      setError(e);
    }
    notifyListeners();
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
