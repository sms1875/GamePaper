import 'package:flutter/material.dart';
import 'package:gamepaper/models/game.dart';
import 'package:gamepaper/screens/wallpaper_screen.dart';
import 'package:gamepaper/widgets/common/load_network_image.dart';

class GameCarouselItem extends StatelessWidget {
  final Game game;

  const GameCarouselItem({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToWallpaperScreen(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: loadNetworkImage(
              game.thumbnailUrl,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            game.title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _navigateToWallpaperScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WallpaperScreen(game: game),
      ),
    );
  }
}