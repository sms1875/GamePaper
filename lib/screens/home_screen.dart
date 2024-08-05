import 'package:flutter/material.dart';
import 'package:wallpaper/data/game_list.dart';
import 'package:wallpaper/models/game.dart';
import 'package:wallpaper/repository/fetchGameList.dart';
import 'package:wallpaper/widgets/alphabet_game_section.dart';

/// HomeScreen 위젯
///
/// 이 위젯은 앱의 메인 화면을 구성합니다. 게임 목록을 알파벳별로 그룹화하여 표시하며,
/// 각 알파벳 섹션을 [AlphabetGameSection] 위젯을 사용하여 렌더링합니다.
///
/// 상태를 가지는 위젯으로, 현재 선택된 알파벳을 관리합니다.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, List<Game>>>? _gameMapFuture;
  String? selectedAlphabet;

  @override
  void initState() {
    super.initState();
    _gameMapFuture = _loadGames();
  }

  Future<Map<String, List<Game>>> _loadGames() async {
    final games = await fetchGameList();
    return _groupGamesByAlphabet(games);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: FutureBuilder<Map<String, List<Game>>>(
        future: _gameMapFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No games available'));
          }

          final gameMap = snapshot.data!;
          return ListView.builder(
            itemCount: gameMap.length,
            itemBuilder: (BuildContext context, int index) {
              final String alphabet = gameMap.keys.elementAt(index);
              final List<Game> gamesByAlphabet = gameMap[alphabet]!;

              return AlphabetGameSection(
                alphabet: alphabet,
                games: gamesByAlphabet,
                isSelected: selectedAlphabet == alphabet,
                onAlphabetTap: () {
                  setState(() {
                    selectedAlphabet = (selectedAlphabet == alphabet) ? null : alphabet;
                  });
                },
              );
            },
          );
        },
      ),
    );
  }

  /// 게임 목록을 알파벳별로 그룹화하는 메서드
  ///
  /// [games]: 그룹화할 게임 목록
  ///
  /// 반환값: 알파벳을 키로, 해당 알파벳으로 시작하는 게임 목록을 값으로 가지는 Map
  static Map<String, List<Game>> _groupGamesByAlphabet(List<Game> games) {
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