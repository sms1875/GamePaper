import 'package:flutter/material.dart';
import 'package:wallpaper/models/game.dart';

class GameShortcut extends StatelessWidget {
  final Game game;
  final VoidCallback onTap;

  const GameShortcut({
    Key? key,
    required this.game,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 70,
            width: 70,
            color: Colors.white,
            child: Image.asset(
              game.image,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              game.title,
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