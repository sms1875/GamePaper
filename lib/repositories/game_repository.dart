import 'package:firebase_storage/firebase_storage.dart';
import 'package:wallpaper/models/game.dart';

class GameRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  Future<List<String>> getWallpapersForPage(
      Reference wallpapersRef,
      int page,
      int wallpapersPerPage,
      ) async {
    try {
      final int startIndex = (page - 1) * wallpapersPerPage;
      final int endIndex = startIndex + wallpapersPerPage;

      final ListResult result = await wallpapersRef.listAll();
      final List<Reference> pageRefs = result.items.sublist(
        startIndex,
        endIndex > result.items.length ? result.items.length : endIndex,
      );

      return await Future.wait(pageRefs.map((ref) => ref.getDownloadURL()));
    } catch (e) {
      print('Error loading wallpapers for page $page: $e');
      return [];
    }
  }
}