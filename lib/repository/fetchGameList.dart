import 'package:wallpaper/models/game.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<List<Game>> fetchGameList() async {
  final storage = FirebaseStorage.instance;
  final gamesRef = storage.ref().child('games');

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
          thumbnail: thumbnailUrl,
        ));
      }
    }

    return games;
  } catch (e) {
    print('Error fetching game list: $e');
    return [];
  }
}