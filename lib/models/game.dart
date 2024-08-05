import 'package:firebase_storage/firebase_storage.dart';
import 'package:wallpaper/models/wallpaper.dart';

class Game {
  final String title;
  final String thumbnailUrl;
  final Reference wallpapersRef;
  Wallpaper? _wallpaper;

  Game({
    required this.title,
    required this.thumbnailUrl,
    required this.wallpapersRef,
  });

  Future<Wallpaper> get wallpaper async {
    if (_wallpaper == null) {
      await _loadWallpaper();
    }
    return _wallpaper!;
  }

  Future<void> _loadWallpaper() async {
    try {
      final wallpapers = await wallpapersRef.listAll();
      final urls = await Future.wait(
          wallpapers.items.map((ref) => ref.getDownloadURL())
      );
      _wallpaper = Wallpaper.fromUrls(urls);
    } catch (e) {
      print('Error loading wallpaper URLs: $e');
      _wallpaper = Wallpaper(pageNumbers: [], wallpapersByPage: []);
    }
  }
}