import 'package:flutter/material.dart';
import 'package:wallpaper/data/wallpaper.dart';
import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

abstract class AbstractWallpaperProvider extends ChangeNotifier {
  final AbstractWallpaperRepository _wallpaperRepository;
  Wallpaper wallpaperPage = Wallpaper(page: 1, pageUrlsList: [], wallpapers: []);

  AbstractWallpaperProvider(this._wallpaperRepository);

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

  Future<void> getPage(int page) async {
    setLoading(true);
    currentPageIndex = page;
    try {
      final result = await _wallpaperRepository.fetchPageCache(
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
      getPage(nextPage);
    }
  }

  void prevPage() {
    final prevPage = wallpaperPage.page - 1;
    if (prevPage > 0) {
      getPage(prevPage);
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

class WallpaperProvider extends AbstractWallpaperProvider {
  WallpaperProvider(AbstractWallpaperRepository repository) : super(repository);
}

class GameProviderFactory {
  static AbstractWallpaperProvider createProvider(AbstractWallpaperRepository repository) {
    return WallpaperProvider(repository);
  }
}