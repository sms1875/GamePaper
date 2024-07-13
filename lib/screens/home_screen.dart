import 'package:flutter/material.dart';
import 'package:wallpaper/data/game_list.dart';
import 'package:wallpaper/models/game.dart';
import 'package:wallpaper/screens/wallpaper_screen.dart';
import 'package:wallpaper/widgets/game_grid.dart';
import 'package:wallpaper/providers/wallpaper_provider_factory.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameMap = _groupGamesByAlphabet(gameList);

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: ListView.builder(
        itemCount: gameMap.length,
        itemBuilder: (BuildContext context, int index) {
          final alphabet = gameMap.keys.elementAt(index);
          final gamesByAlphabet = gameMap[alphabet]!;

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
                GameGrid(
                  games: gamesByAlphabet,
                  onGameTap: (Game game) => _navigateToWallpaperScreen(context, game),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToWallpaperScreen(BuildContext context, Game game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WallpaperScreen(
          wallpaperProvider: WallpaperProviderFactory.createProvider(game.repository),
        ),
      ),
    );
  }

  Map<String, List<Game>> _groupGamesByAlphabet(List<Game> games) {
    final gameMap = <String, List<Game>>{};

    for (final game in games) {
      final alphabet = game.title[0].toUpperCase();
      gameMap.putIfAbsent(alphabet, () => <Game>[]);
      gameMap[alphabet]!.add(game);
    }

    return Map.fromEntries(gameMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }
}