import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gamepaper/config/api_config.dart';
import 'package:gamepaper/models/game.dart';

class GameRepository {
  // Singleton instance
  static final GameRepository _instance = GameRepository._internal();

  factory GameRepository() => _instance;
  GameRepository._internal();

  final Map<int, List<Game>> _gameCache = {};
  final Map<String, List<Wallpaper>> _wallpaperCache = {};

  Future<List<Game>> fetchGameList() async {
    if (_gameCache.containsKey(0)) {
      return _gameCache[0]!;
    }

    final response = await http
        .get(
          Uri.parse(ApiConfig.gamesUrl()),
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final games = data.map((json) => Game.fromServerJson(json)).toList();
      _gameCache[0] = games;
      return games;
    } else {
      throw Exception('게임 목록 조회 실패: ${response.statusCode}');
    }
  }

  /// 배경화면 페이지 조회 (page: 1-indexed, 서버는 0-indexed)
  Future<List<Wallpaper>> getWallpapersForPage(
    int gameId,
    int page,
    int wallpapersPerPage,
  ) async {
    final cacheKey = '${gameId}_$page';
    if (_wallpaperCache.containsKey(cacheKey)) {
      return _wallpaperCache[cacheKey]!;
    }

    final serverPage = page - 1; // 1-indexed → 0-indexed
    final response = await http
        .get(
          Uri.parse(ApiConfig.wallpapersUrl(
            gameId,
            page: serverPage,
            size: wallpapersPerPage,
          )),
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> content = data['content'];
      final wallpapers =
          content.map((json) => Wallpaper.fromServerJson(json)).toList();
      _wallpaperCache[cacheKey] = wallpapers;
      return wallpapers;
    } else {
      throw Exception('배경화면 조회 실패: ${response.statusCode}');
    }
  }

  void clearCache() {
    _gameCache.clear();
    _wallpaperCache.clear();
  }
}
