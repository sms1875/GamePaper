import 'package:flutter/material.dart';
import 'package:wallpaper/data/game_list.dart';
import 'package:wallpaper/models/game.dart';
import 'package:wallpaper/screens/wallpaper_screen.dart';
import 'package:wallpaper/widgets/home_carousel.dart';
import 'package:wallpaper/providers/wallpaper_provider_factory.dart';
import '../repository/wallpaper_repository_builder.dart';

/// 홈 화면을 구성하는 StatelessWidget입니다.
///
/// 이 위젯은 게임 목록을 알파벳별로 그룹화하여 표시하고,
/// 각 그룹에 대해 캐러셀을 제공합니다.
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Game>> gameMap = _groupGamesByAlphabet(gameList);

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: ListView.builder(
        itemCount: gameMap.length,
        itemBuilder: (BuildContext context, int index) {
          final String alphabet = gameMap.keys.elementAt(index);
          final List<Game> gamesByAlphabet = gameMap[alphabet]!;

          return _buildGameSection(alphabet, gamesByAlphabet, context);
        },
      ),
    );
  }

  /// 알파벳과 게임 목록을 포함한 섹션을 빌드합니다.
  ///
  /// [alphabet]은 섹션의 제목을 나타내며, [gamesByAlphabet]은 이 섹션에 표시될 게임 목록입니다.
  /// [context]는 네비게이션을 위해 사용됩니다.
  Widget _buildGameSection(String alphabet, List<Game> gamesByAlphabet, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAlphabetHeader(alphabet),
          HomeCarousel(
            games: gamesByAlphabet,
            onGameTap: (Game game) => _navigateToWallpaperScreen(context, game),
          ),
        ],
      ),
    );
  }

  /// 알파벳 제목을 표시하는 위젯입니다.
  ///
  /// [alphabet]은 표시할 알파벳을 나타냅니다.
  Widget _buildAlphabetHeader(String alphabet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(
        alphabet.toUpperCase(),
        style: const TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// 선택한 게임의 상세 화면으로 이동합니다.
  ///
  /// [context]는 네비게이션을 위해 사용되며, [game]은 상세 화면으로 이동할 게임을 나타냅니다.
  void _navigateToWallpaperScreen(BuildContext context, Game game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WallpaperScreen(
          wallpaperProvider: WallpaperProviderFactory.createProvider(
            WallpaperRepositoryBuilder().fromData(game.repository).build(),
          ),
        ),
      ),
    );
  }

  /// 게임 리스트를 알파벳별로 그룹화합니다.
  ///
  /// [games]는 그룹화할 게임 목록을 나타냅니다.
  /// 반환된 맵은 알파벳을 키로 하고, 각 알파벳에 해당하는 게임 목록을 값으로 갖습니다.
  Map<String, List<Game>> _groupGamesByAlphabet(List<Game> games) {
    final Map<String, List<Game>> gameMap = {};

    for (final game in games) {
      final String alphabet = game.title[0].toUpperCase();
      gameMap.putIfAbsent(alphabet, () => <Game>[]);
      gameMap[alphabet]!.add(game);
    }

    // 알파벳 순서로 정렬된 맵 반환
    return Map.fromEntries(
      gameMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }
}
