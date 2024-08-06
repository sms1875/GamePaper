import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/models/game.dart';
import 'package:wallpaper/widgets/alphabet_game_section.dart';

import '../providers/game_provider.dart';

/// HomeScreen 위젯
///
/// 이 위젯은 앱의 메인 화면을 구성합니다. 게임 목록을 알파벳별로 그룹화하여 표시하며,
/// 각 알파벳 섹션을 [AlphabetGameSection] 위젯을 사용하여 렌더링합니다.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedAlphabet;

  @override
  void initState() {
    super.initState();
    // 게임 목록을 로드
    Provider.of<GameProvider>(context, listen: false).loadGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          if (gameProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (gameProvider.gameMap.isEmpty) {
            return const Center(child: Text('No games available'));
          }

          final gameMap = gameProvider.gameMap;
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
}