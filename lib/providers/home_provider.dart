import 'package:flutter/foundation.dart';
import '../models/game.dart';
import '../repositories/game_repository.dart';

class HomeProvider with ChangeNotifier {
  final GameRepository _repository;
  Map<String, List<Game>> _gameMap = {};
  bool _isLoading = false;

  HomeProvider(this._repository);

  Map<String, List<Game>> get gameMap => _gameMap;
  bool get isLoading => _isLoading;

  Future<void> loadGames() async {
    _isLoading = true;
    notifyListeners();

    final games = await _repository.fetchGameList();
    _gameMap = _groupGamesByAlphabet(games);

    _isLoading = false;
    notifyListeners();
  }

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
