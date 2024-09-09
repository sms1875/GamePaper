import 'package:flutter/foundation.dart';
import 'package:gamepaper/models/game.dart';
import '../repositories/game_repository.dart';

class HomeProvider with ChangeNotifier {
  final GameRepository _repository;
  Map<String, List<Game>> _gameMap = {};
  bool _isLoading = false;
  String _errorMessage = '';

  HomeProvider({required GameRepository repository}) : _repository = repository;

  Map<String, List<Game>> get gameMap => _gameMap;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadGames() async {
    _setLoadingState(true);
    _setErrorMessage('');

    try {
      final games = await _repository.fetchGameList();
      _gameMap = _groupGamesByAlphabet(games);
    } catch (e) {
      _setErrorMessage(e.toString());
    }

    _setLoadingState(false);
  }

  Map<String, List<Game>> _groupGamesByAlphabet(List<Game> games) {
    final gameMap = games.fold<Map<String, List<Game>>>({}, (map, game) {
      final alphabet = game.title[0].toUpperCase();
      map.putIfAbsent(alphabet, () => []).add(game);
      return map;
    });
    return Map.fromEntries(gameMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
