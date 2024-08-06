import 'package:firebase_storage/firebase_storage.dart';

class Game {
  final String title;
  final String thumbnailUrl;
  final Reference wallpapersRef;
  int? _totalWallpapers;

  Game({
    required this.title,
    required this.thumbnailUrl,
    required this.wallpapersRef,
  });

  Future<int> get totalWallpapers async {
    if (_totalWallpapers == null) {
      await _loadTotalWallpapers();
    }
    return _totalWallpapers!;
  }

  Future<void> _loadTotalWallpapers() async {
    try {
      final ListResult result = await wallpapersRef.listAll();
      _totalWallpapers = result.items.length;
    } catch (e) {
      print('Error loading total wallpapers: $e');
      _totalWallpapers = 0;
    }
  }

  Future<List<String>> getWallpapersForPage(int page, int wallpapersPerPage) async {
    try {
      final int startIndex = (page - 1) * wallpapersPerPage;
      final int endIndex = startIndex + wallpapersPerPage;

      final ListResult result = await wallpapersRef.listAll();
      final List<Reference> pageRefs = result.items.sublist(
          startIndex,
          endIndex > result.items.length ? result.items.length : endIndex
      );

      return await Future.wait(pageRefs.map((ref) => ref.getDownloadURL()));
    } catch (e) {
      print('Error loading wallpapers for page $page: $e');
      return [];
    }
  }
}

class Wallpaper {
  final int pageNumber;
  final List<String> wallpaperUrls;

  Wallpaper({
    required this.pageNumber,
    required this.wallpaperUrls,
  });
}