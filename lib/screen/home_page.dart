import 'package:flutter/material.dart';
import 'package:wallpaper/data/game_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 알파벳 순서 정렬
    gameList.sort((a, b) => a['title'].compareTo(b['title']));

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: buildGameGrid(context, gameList),
          ),
        ],
      ),
    );
  }

  Widget buildGameGrid(BuildContext context, List<Map<String, dynamic>> games) {
    final gameMap = groupGamesByAlphabet(games);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: gameMap.length,
      itemBuilder: (BuildContext context, int index) {
        final alphabet = gameMap.keys.elementAt(index);
        final gamesByAlphabet = gameMap[alphabet]!;

        // 알파벳과 해당 알파벳으로 시작하는 게임 그룹
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                alphabet.toUpperCase(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
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
                  game['page'],
                );
              },
            ),
          ],
        );
      },
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
  Widget buildGameShortcut(BuildContext context, String title, String image, Widget nextPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 아이콘 이미지
          Image.asset(
            image,
            height: 80,
            width: 80,
          ),
          // 아이콘 타이틀
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
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
