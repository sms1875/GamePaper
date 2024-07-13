import 'package:flutter/material.dart';
import 'package:wallpaper/models/game.dart';
import 'package:wallpaper/widgets/game_shortcut.dart';

class GameGrid extends StatelessWidget {
  final List<Game> games;
  final Function(Game) onGameTap;

  const GameGrid({
    Key? key,
    required this.games,
    required this.onGameTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
      ),
      itemCount: games.length,
      itemBuilder: (BuildContext context, int index) {
        return GameShortcut(
          game: games[index],
          onTap: () => onGameTap(games[index]),
        );
      },
    );
  }
}