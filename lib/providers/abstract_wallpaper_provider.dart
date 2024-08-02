import 'package:flutter/material.dart';
import 'package:wallpaper/models/wallpaper.dart';
import 'package:wallpaper/repository/wallpaper_repository.dart';

abstract class AbstractWallpaperProvider extends ChangeNotifier {
  final PageController pageController = PageController();
  final WallpaperRepository _wallpaperRepository;
  Wallpaper wallpaperPage = Wallpaper(pageNumbers: [], pageUrls: [], wallpapersByPage: []);

  AbstractWallpaperProvider(this._wallpaperRepository);

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error {
    final error = _error;
    _error = null;
    return error;
  }

  int currentPageIndex = 0;

  Future<void> update() async {
    _setLoading(true);
    try {
      currentPageIndex = 0;
      wallpaperPage = await _wallpaperRepository.fetchWallpapers();
    } catch (e) {
      _setError(e);
    }
    _setLoading(false);
  }

  void nextPage() {
    final nextPage = currentPageIndex + 1;
    if (nextPage < wallpaperPage.wallpapersByPage.length) {
      currentPageIndex = nextPage;
      notifyListeners();
    }
  }

  void prevPage() {
    final prevPage = currentPageIndex - 1;
    if (prevPage >= 0) {
      currentPageIndex = prevPage;
      notifyListeners();
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