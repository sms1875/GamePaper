import 'package:firebase_storage/firebase_storage.dart';

/// Game 모델
///
/// 게임 제목, 썸네일 URL, 월페이퍼 참조를 포함하는 데이터 클래스
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

  /// 총 월페이퍼 수를 비동기로 반환
  Future<int> get totalWallpapers async {
    if (_totalWallpapers == null) {
      await _loadTotalWallpapers();
    }
    return _totalWallpapers!;
  }

  /// 총 월페이퍼 수를 비동기로 로드
  Future<void> _loadTotalWallpapers() async {
    try {
      final ListResult result = await wallpapersRef.listAll();
      _totalWallpapers = result.items.length;
    } catch (e) {
      print('Error loading total wallpapers: $e');
      _totalWallpapers = 0;
    }
  }

  /// 특정 페이지의 월페이퍼 URL 목록을 비동기로 반환
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
