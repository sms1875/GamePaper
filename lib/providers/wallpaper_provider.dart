import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:gamepaper/models/game.dart';
import '../repositories/game_repository.dart';

class WallpaperProvider with ChangeNotifier {
  final Game game;
  late Future<int> _totalWallpapersFuture;
  final int wallpapersPerPage = 12;
  final GameRepository _repository = GameRepository();

  // 캐시된 월페이퍼 리스트
  Map<int, List<String>> _wallpaperCache = {};

  WallpaperProvider({required this.game}) {
    _totalWallpapersFuture = _getTotalWallpapers();
  }

  Future<int> get totalWallpapersFuture => _totalWallpapersFuture;

  // 특정 페이지의 월페이퍼를 가져오는 함수
  Future<List<String>> getWallpapersForPage(int page) async {
    if (_wallpaperCache.containsKey(page)) {
      return _wallpaperCache[page]!;
    }

    try {
      List<String> wallpapers = await _repository.getWallpapersForPage(game.wallpapersRef, page, wallpapersPerPage);
      _wallpaperCache[page] = wallpapers;
      return wallpapers;
    } catch (error) {
      throw error; // Pass error to be handled by the UI layer
    }
  }

  // 월페이퍼 총 개수를 비동기적으로 가져옴
  Future<int> _getTotalWallpapers() async {
    final ListResult result = await game.wallpapersRef.listAll();
    return result.items.length;
  }

  // 월페이퍼 목록을 다시 불러오는 함수 (에러 발생 시 재시도용)
  void loadWallpapers() {
    _totalWallpapersFuture = _getTotalWallpapers();
    _wallpaperCache.clear();
    notifyListeners();
  }
}
