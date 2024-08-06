import 'package:firebase_storage/firebase_storage.dart';

import '../models/game.dart';

/// 게임 목록을 Firebase에서 가져오는 리포지토리 클래스
class GameRepository {
  final FirebaseStorage _storage;

  GameRepository(this._storage);

  /// 게임 목록을 비동기로 가져옴
  Future<List<Game>> fetchGameList() async {
    final gamesRef = _storage.ref().child('games');

    try {
      final result = await gamesRef.listAll();
      List<Game> games = [];

      for (var prefix in result.prefixes) {
        final gameName = prefix.name;
        final wallpapersRef = prefix.child('wallpapers');
        final wallpapers = await wallpapersRef.listAll();

        if (wallpapers.items.isNotEmpty) {
          final thumbnailRef = wallpapers.items[0];
          final thumbnailUrl = await thumbnailRef.getDownloadURL();

          games.add(Game(
            title: gameName,
            thumbnailUrl: thumbnailUrl,
            wallpapersRef: wallpapersRef,
          ));
        }
      }

      return games;
    } catch (e) {
      print('Error fetching game list: $e');
      return [];
    }
  }
}
