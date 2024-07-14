import 'package:flutter/material.dart';
import 'package:wallpaper/models/wallpaper.dart';
import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

abstract class AbstractWallpaperProvider extends ChangeNotifier {
  final AbstractWallpaperRepository _wallpaperRepository;
  Wallpaper wallpaperPage = Wallpaper(page: 1, pageUrlsList: [], wallpapers: []);

  AbstractWallpaperProvider(this._wallpaperRepository);

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error {
    final error = _error;
    _error = null;
    return error;
  }

  List<int> pageNumbers = [];
  int currentPageIndex = 1;

  Future<void> update() async {
    _setLoading(true);
    try {
      currentPageIndex = 1;
      wallpaperPage = await _wallpaperRepository.fetchWallpaper();
      pageNumbers = List.generate(wallpaperPage.pageUrlsList.length, (index) => index + 1);
    } catch (e) {
      _setError(e);
    }
    _setLoading(false);
  }

  Future<void> getPage(int page) async {
    _setLoading(true);
    currentPageIndex = page;
    try {
      final result = await _wallpaperRepository.fetchPageCache(page, wallpaperPage.pageUrlsList);
      wallpaperPage = Wallpaper(page: page, pageUrlsList: wallpaperPage.pageUrlsList, wallpapers: result);
    } catch (e) {
      _setError(e);
    }
    _setLoading(false);
  }

  void nextPage() {
    final nextPage = currentPageIndex + 1;
    if (nextPage <= pageNumbers.length) {
      getPage(nextPage);
    }
  }

  void prevPage() {
    final prevPage = currentPageIndex - 1;
    if (prevPage > 0) {
      getPage(prevPage);
    }
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setError(Object error) {
    print(error);
    _error = error;
    notifyListeners();
  }
}