import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:gamepaper/models/game.dart';
import '../repositories/game_repository.dart';

class WallpaperProvider with ChangeNotifier {
  final Game game;
  final GameRepository _repository;
  late Future<int> _totalWallpapersFuture;
  final int wallpapersPerPage = 12;

  Map<int, List<Wallpaper>> _wallpaperCache = {};

  WallpaperProvider({required this.game, required GameRepository repository})
      : _repository = repository {
    _totalWallpapersFuture = _getTotalWallpapers();
  }

  Future<int> get totalWallpapersFuture => _totalWallpapersFuture;

  Future<List<Wallpaper>> getWallpapersForPage(int page) async {
    if (_wallpaperCache.containsKey(page)) {
      return _wallpaperCache[page]!;
    }

    try {
      List<Wallpaper> wallpapers = await _repository.getWallpapersForPage(
        game.wallpapersRef,
        page,
        wallpapersPerPage,
      );
      _wallpaperCache[page] = wallpapers;
      return wallpapers;
    } catch (error) {
      throw error;
    }
  }

  Future<int> _getTotalWallpapers() async {
    final ListResult result = await game.wallpapersRef.listAll();
    return result.items.length;
  }

  void loadWallpapers() {
    _totalWallpapersFuture = _getTotalWallpapers();
    _wallpaperCache.clear();
    notifyListeners();
  }
}