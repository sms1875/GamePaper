import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:gamepaper/models/game.dart';
import '../repositories/game_repository.dart';
import '../utils/firebase_util.dart'; // 유틸리티 함수 사용

class WallpaperProvider with ChangeNotifier {
  final Game game;
  late Future<int> _totalWallpapersFuture; // 월페이퍼 총 개수 비동기 계산
  final int wallpapersPerPage = 12; // 페이지당 표시할 월페이퍼 개수
  final GameRepository _repository = GameRepository();

  WallpaperProvider({required this.game}) {
    _totalWallpapersFuture = _getTotalWallpapers(); // 생성자에서 총 월페이퍼 수 계산
  }

  // 월페이퍼 총 개수
  Future<int> get totalWallpapersFuture => _totalWallpapersFuture;

  // 특정 페이지의 월페이퍼 가져오기
  Future<List<String>> getWallpapersForPage(int page) async {
    // 월페이퍼 목록 불러오기
    ListResult result = await game.wallpapersRef.listAll();

    // 정렬된 월페이퍼 목록에서 페이징 처리 후 해당 페이지의 URL 가져오기
    List<Reference> sortedItems = sortItemsByNumber(result.items.toList());
    return await fetchWallpapersBatch(sortedItems, page, wallpapersPerPage);
  }

  // 월페이퍼 총 개수를 비동기적으로 가져오는 함수
  Future<int> _getTotalWallpapers() async {
    final ListResult result = await game.wallpapersRef.listAll();
    return result.items.length;
  }
}
