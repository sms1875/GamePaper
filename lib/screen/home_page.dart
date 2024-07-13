import 'package:flutter/material.dart';
import 'package:wallpaper/data/game_list.dart';
import 'package:wallpaper/screen/concrete_wallpaper_screen.dart';
import 'package:wallpaper/provider/abstract_wallpaper_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 알파벳 순서 정렬
    gameList.sort((a, b) => a['title'].compareTo(b['title']));

    final gameMap = groupGamesByAlphabet(gameList);

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: ListView.builder(
        itemCount: gameMap.length,
        itemBuilder: (BuildContext context, int index) {
          final alphabet = gameMap.keys.elementAt(index);
          final gamesByAlphabet = gameMap[alphabet]!;

          // 알파벳과 해당 알파벳으로 시작하는 게임 그룹
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    alphabet.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: gamesByAlphabet.length,
                  itemBuilder: (BuildContext context, int index) {
                    final game = gamesByAlphabet[index];
                    return buildGameShortcut(
                      context,
                      game['title'],
                      game['image'],
                      GameProviderFactory.createProvider(game['repository']),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 알파벳 순서로 게임을 그룹화
  Map<String, List<Map<String, dynamic>>> groupGamesByAlphabet(List<Map<String, dynamic>> games) {
    final gameMap = <String, List<Map<String, dynamic>>>{};

    for (final game in games) {
      final title = game['title'];
      final alphabet = title[0].toUpperCase();

      gameMap.putIfAbsent(alphabet, () => <Map<String, dynamic>>[]);
      gameMap[alphabet]!.add(game);
    }

    return gameMap;
  }

  // 게임 바로가기 위젯
  Widget buildGameShortcut(BuildContext context, String title, String image, AbstractWallpaperProvider provider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConcreteWallpaperScreen(wallpaperProvider: provider)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 게임 아이콘
          Container(
            height: 70,
            width: 70,
            color: Colors.white,
            child: Image.asset(
              image,
            ),
          ),
          // 게임 제목
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(0.5, 0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
              // 최대 두 줄까지, 글자를 가운데로 정렬, 넘치는 글자는 ...으로 표시
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}