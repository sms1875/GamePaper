import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gamepaper/models/game.dart';

class GameRepository {
  // Singleton instance
  static final GameRepository _instance = GameRepository._internal();

  // Factory constructor
  factory GameRepository() {
    return _instance;
  }

  // Private constructor
  GameRepository._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Map<String, Game> _gameCache = {};
  final Map<String, List<Wallpaper>> _wallpaperCache = {};

  Future<List<Game>> fetchGameList() async {
    if (_gameCache.isNotEmpty) {
      return _gameCache.values.toList();
    }

    final gamesRef = _storage.ref().child('games');

    try {
      final result = await gamesRef.listAll();
      final games = await Future.wait(result.prefixes.map(_fetchGameThumbnail));

      _gameCache.addAll({for (var game in games.whereType<Game>()) game.title: game});
      return _gameCache.values.toList();
    } catch (e) {
      throw Exception('Error fetching game list: $e');
    }
  }

  Future<Game?> _fetchGameThumbnail(Reference prefix) async {
    final gameName = prefix.name;
    final wallpapersRef = prefix.child('wallpapers');

    try {
      final wallpapers = await wallpapersRef.list(ListOptions(maxResults: 1));

      if (wallpapers.items.isNotEmpty) {
        final thumbnailRef = wallpapers.items[0];
        final thumbnailUrl = await thumbnailRef.getDownloadURL();
        final thumbnail = _createWallpaper(thumbnailRef.name, thumbnailUrl);

        return Game(
          title: gameName,
          thumbnail: thumbnail,
          wallpapersRef: wallpapersRef,
        );
      }
    } catch (e) {
      print('Error fetching wallpapers for game $gameName: $e');
    }
    return null;
  }

  Future<List<Wallpaper>> getWallpapersForPage(Reference wallpapersRef, int page, int wallpapersPerPage) async {
    final cacheKey = '${wallpapersRef.fullPath}_$page';

    if (_wallpaperCache.containsKey(cacheKey)) {
      return _wallpaperCache[cacheKey]!;
    }

    try {
      final result = await wallpapersRef.list(ListOptions(
        maxResults: wallpapersPerPage,
        pageToken: (page > 1) ? (await wallpapersRef.list(ListOptions(maxResults: (page - 1) * wallpapersPerPage))).nextPageToken : null,
      ));

      final wallpapers = await Future.wait(result.items.map((ref) async {
        final url = await ref.getDownloadURL();
        return _createWallpaper(ref.name, url);
      }));

      _wallpaperCache[cacheKey] = wallpapers;
      return wallpapers;
    } catch (e) {
      throw Exception('Error loading wallpapers for page $page: $e');
    }
  }

  Wallpaper _createWallpaper(String fileName, String url) {
    final blurHashBase64 = fileName.split('#').length > 1 ? fileName.split('#')[1].split('.')[0] : null;
    final blurHash = blurHashBase64 != null ? utf8.decode(base64.decode(blurHashBase64)) : null;
    return Wallpaper(url: url, blurHash: blurHash);
  }

  void clearCache() {
    _gameCache.clear();
    _wallpaperCache.clear();
  }
}