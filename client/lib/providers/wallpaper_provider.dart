import 'package:flutter/foundation.dart';
import 'package:gamepaper/models/game.dart';
import '../repositories/game_repository.dart';

class WallpaperProvider with ChangeNotifier {
  final Game game;
  final GameRepository _repository;
  late Future<int> _totalWallpapersFuture;
  final int wallpapersPerPage = 12;

  final Map<int, List<Wallpaper>> _wallpaperCache = {};

  WallpaperProvider({required this.game, required GameRepository repository})
      : _repository = repository {
    _totalWallpapersFuture = Future.value(game.wallpaperCount);
  }

  Future<int> get totalWallpapersFuture => _totalWallpapersFuture;

  Future<List<Wallpaper>> getWallpapersForPage(int page) async {
    if (_wallpaperCache.containsKey(page)) {
      return _wallpaperCache[page]!;
    }

    try {
      final wallpapers = await _repository.getWallpapersForPage(
        game.id,
        page,
        wallpapersPerPage,
      );
      _wallpaperCache[page] = wallpapers;
      return wallpapers;
    } catch (error) {
      rethrow;
    }
  }

  void loadWallpapers() {
    _totalWallpapersFuture = Future.value(game.wallpaperCount);
    _wallpaperCache.clear();
    notifyListeners();
  }
}
