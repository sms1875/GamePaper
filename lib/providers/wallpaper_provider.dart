import 'package:flutter/foundation.dart';
import '../models/game.dart';

class WallpaperProvider with ChangeNotifier {
  final Game game;
  late Future<int> _totalWallpapersFuture;
  final int wallpapersPerPage = 12;

  WallpaperProvider(this.game) {
    _totalWallpapersFuture = game.totalWallpapers;
  }

  Future<int> get totalWallpapersFuture => _totalWallpapersFuture;

  Future<List<String>> getWallpapersForPage(int page) {
    return game.getWallpapersForPage(page, wallpapersPerPage);
  }
}
