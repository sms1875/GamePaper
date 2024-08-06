import 'package:flutter/foundation.dart';

import '../models/game.dart';
import '../repositories/game_repository.dart';

/// 게임 목록 데이터를 관리하는 Provider 클래스
class GameProvider with ChangeNotifier {
  final GameRepository _repository;
  Map<String, List<Game>> _gameMap = {};
  bool _isLoading = false;

  GameProvider(this._repository);

  Map<String, List<Game>> get gameMap => _gameMap;
  bool get isLoading => _isLoading;

  /// 게임 목록을 알파벳별로 그룹화하여 로드
  Future<void> loadGames() async {
    _isLoading = true;
    notifyListeners();

    final games = await _repository.fetchGameList();
    _gameMap = _groupGamesByAlphabet(games);

    _isLoading = false;
    notifyListeners();
  }

  /// 게임 목록을 알파벳별로 그룹화하는 메서드
  Map<String, List<Game>> _groupGamesByAlphabet(List<Game> games) {
    final Map<String, List<Game>> gameMap = {};

    for (final game in games) {
      final String alphabet = game.title[0].toUpperCase();
      gameMap.putIfAbsent(alphabet, () => <Game>[]);
      gameMap[alphabet]!.add(game);
    }

    return Map.fromEntries(
      gameMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }
}
