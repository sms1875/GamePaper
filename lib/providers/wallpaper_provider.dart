import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:gamepaper/models/game.dart';

import '../repositories/game_repository.dart';

class WallpaperProvider with ChangeNotifier {
  final Game game;
  late Future<int> _totalWallpapersFuture;
  final int wallpapersPerPage = 12;
  final GameRepository _repository = GameRepository();

  WallpaperProvider({required this.game}) {
    _totalWallpapersFuture = _getTotalWallpapers();
  }

  Future<int> get totalWallpapersFuture => _totalWallpapersFuture;

  Future<List<String>> getWallpapersForPage(int page) {
    return _repository.getWallpapersForPage(game.wallpapersRef, page, wallpapersPerPage);
  }

  Future<int> _getTotalWallpapers() async {
    final ListResult result = await game.wallpapersRef.listAll();
    return result.items.length;
  }
}