import 'package:firebase_storage/firebase_storage.dart';
import 'package:gamepaper/models/game.dart';

class GameRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 게임 목록을 가져오는 함수
  Future<List<Game>> fetchGameList() async {
    final gamesRef = _storage.ref().child('games');

    try {
      // 'games' 디렉토리의 모든 하위 폴더를 가져옴
      final result = await gamesRef.listAll();
      List<Game> games = [];

      // 각 게임 폴더에 대해 월페이퍼를 불러옴
      for (var prefix in result.prefixes) {
        final game = await _fetchGameWithWallpapers(prefix);
        if (game != null) {
          games.add(game); // 월페이퍼가 있으면 게임 목록에 추가
        }
      }
      return games;
    } catch (e) {
      // 에러 발생 시 메시지 포함
      throw Exception('Error fetching game list: $e');
    }
  }

  // 각 게임에 대한 월페이퍼를 가져오는 함수
  Future<Game?> _fetchGameWithWallpapers(Reference prefix) async {
    final gameName = prefix.name; // 폴더 이름 = 게임 이름
    final wallpapersRef = prefix.child('wallpapers');

    try {
      final wallpapers = await wallpapersRef.listAll();

      // 월페이퍼가 있으면 첫 번째 이미지를 썸네일로 사용
      if (wallpapers.items.isNotEmpty) {
        final thumbnailRef = wallpapers.items[0];
        final thumbnailUrl = await thumbnailRef.getDownloadURL(); // 썸네일 URL 가져오기

        return Game(
          title: gameName,
          thumbnailUrl: thumbnailUrl,
          wallpapersRef: wallpapersRef, // 월페이퍼 레퍼런스 저장
        );
      }
      return null; // 월페이퍼가 없으면 null 반환
    } catch (e) {
      // 에러 발생 시 메시지 포함
      throw Exception('Error fetching wallpapers for game $gameName: $e');
    }
  }

  // 월페이퍼를 페이지 단위로 가져오는 함수
  Future<List<String>> getWallpapersForPage(
      Reference wallpapersRef, int page, int wallpapersPerPage) async {
    try {
      // 월페이퍼 목록을 불러옴
      final ListResult result = await wallpapersRef.listAll();

      // 페이지 배치를 계산하여 월페이퍼 URL 가져오기
      return await _fetchWallpapersBatch(result.items, page, wallpapersPerPage);
    } catch (e) {
      // 에러 발생 시 메시지 포함
      throw Exception('Error loading wallpapers for page $page: $e');
    }
  }

  // 페이지 단위로 월페이퍼를 배치로 가져오는 함수
  Future<List<String>> _fetchWallpapersBatch(
      List<Reference> items, int page, int wallpapersPerPage) async {
    final int startIndex = (page - 1) * wallpapersPerPage; // 시작 인덱스 계산
    final int endIndex = startIndex + wallpapersPerPage; // 끝 인덱스 계산

    // 페이징 범위 내에서 레퍼런스 목록 추출
    final List<Reference> pageRefs = items.sublist(
      startIndex,
      endIndex > items.length ? items.length : endIndex, // 마지막 인덱스가 범위 초과할 경우 처리
    );

    // 해당 페이지의 월페이퍼 URL들을 가져옴
    return await Future.wait(pageRefs.map((ref) => ref.getDownloadURL()));
  }
}
