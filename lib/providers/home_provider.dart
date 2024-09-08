import 'package:flutter/foundation.dart';
import 'package:gamepaper/models/game.dart';
import '../repositories/game_repository.dart';

class HomeProvider with ChangeNotifier {
  final GameRepository _repository = GameRepository();
  Map<String, List<Game>> _gameMap = {}; // 알파벳별로 게임을 그룹화한 맵
  bool _isLoading = false; // 로딩 상태 관리
  String _errorMessage = ''; // 에러 메시지 저장

  Map<String, List<Game>> get gameMap => _gameMap;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // 게임 목록을 불러오고 알파벳 순으로 그룹화하는 함수
  Future<void> loadGames() async {
    _setLoadingState(true); // 로딩 상태 시작
    _setErrorMessage(''); // 에러 메시지 초기화

    try {
      final games = await _repository.fetchGameList(); // 게임 목록 불러오기
      _gameMap = _groupGamesByAlphabet(games); // 알파벳 그룹화
    } catch (e) {
      // 에러 발생 시 에러 메시지 설정
      _setErrorMessage(e.toString());
    }

    _setLoadingState(false); // 로딩 상태 종료
  }

  // 게임 목록을 알파벳 순으로 그룹화하는 함수
  Map<String, List<Game>> _groupGamesByAlphabet(List<Game> games) {
    final Map<String, List<Game>> gameMap = {};
    for (final game in games) {
      final String alphabet = game.title[0].toUpperCase(); // 게임 제목의 첫 글자를 기준으로 그룹화
      gameMap.putIfAbsent(alphabet, () => <Game>[]); // 맵에 해당 알파벳 키가 없으면 추가
      gameMap[alphabet]!.add(game);
    }
    // 알파벳 순서대로 정렬하여 반환
    return Map.fromEntries(
      gameMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  // 에러 메시지 설정
  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners(); // 상태 변경을 알림
  }

  // 로딩 상태를 변경하는 헬퍼 함수
  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners(); // 상태 변경을 알림
  }
}
