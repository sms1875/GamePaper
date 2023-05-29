import 'package:flutter/material.dart';
import 'package:wallpaper/data/console_games.dart';
import 'package:wallpaper/data/online_games.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text("온라인 게임", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Expanded(
            child: buildGameGrid(context, onlineGames),
          ),
          const SizedBox(height: 20),
          const Text("콘솔 게임", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Expanded(
            child: buildGameGrid(context, consoleGames),
          ),
        ],
      ),
    );
  }

  Widget buildGameGrid(BuildContext context, List<Map<String, dynamic>> games) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: games.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        return buildButton(context, games[index]['title'], games[index]['image'], games[index]['page']);
      },
    );
  }

  Widget buildButton(BuildContext context, String title, String image, Widget nextPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[300],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 100,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
