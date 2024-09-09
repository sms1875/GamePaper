import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gamepaper/models/game.dart';

class GameRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Map<String, Game> _gameCache = {};
  final Map<String, List<Wallpaper>> _wallpaperCache = {}; // Use Wallpaper instead of String

  Future<List<Game>> fetchGameList() async {
    if (_gameCache.isNotEmpty) {
      return _gameCache.values.toList();
    }

    final gamesRef = _storage.ref().child('games');

    try {
      final result = await gamesRef.listAll();
      final gameFutures = result.prefixes.map(_fetchGameThumbnail);
      final games = await Future.wait(gameFutures);

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

        final fileName = thumbnailRef.name;
        final blurHashBase64 = fileName.split('#')[1].split('.')[0];
        final blurHash = utf8.decode(base64.decode(blurHashBase64));
        Wallpaper thumbnail = Wallpaper(url: thumbnailUrl, blurHash: blurHash);
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

  Future<List<Wallpaper>> getWallpapersForPage(
      Reference wallpapersRef, int page, int wallpapersPerPage) async {
    final cacheKey = '${wallpapersRef.fullPath}_$page';

    if (_wallpaperCache.containsKey(cacheKey)) {
      return _wallpaperCache[cacheKey]!;
    }

    try {
      final result = await wallpapersRef.listAll();
      final wallpapers = await _fetchWallpapersBatch(result.items, page, wallpapersPerPage);

      _wallpaperCache[cacheKey] = wallpapers;
      return wallpapers;
    } catch (e) {
      throw Exception('Error loading wallpapers for page $page: $e');
    }
  }

  Future<List<Wallpaper>> _fetchWallpapersBatch(
      List<Reference> items, int page, int wallpapersPerPage) async {
    final int startIndex = (page - 1) * wallpapersPerPage;
    final int endIndex = startIndex + wallpapersPerPage;

    final List<Reference> pageRefs = items.sublist(
      startIndex,
      endIndex > items.length ? items.length : endIndex,
    );

    return await Future.wait(pageRefs.map((ref) async {
      final url = await ref.getDownloadURL();
      final fileName = ref.name;
      final blurHashBase64 = fileName.contains('#') ? fileName.split('#')[1].split('.')[0] : null;
      final blurHash = blurHashBase64 != null ? utf8.decode(base64.decode(blurHashBase64)) : null;
      return Wallpaper(url: url, blurHash: blurHash);
    }));
  }

  void clearCache() {
    _gameCache.clear();
    _wallpaperCache.clear();
  }
}
