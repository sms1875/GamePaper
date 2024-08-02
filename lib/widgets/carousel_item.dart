import 'package:flutter/material.dart';
import 'package:wallpaper/models/game.dart';

class CarouselItem extends StatelessWidget {
  final Game game;
  final VoidCallback onTap;

  const CarouselItem({
    Key? key,
    required this.game,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(game.image),
                    fit: BoxFit.contain, // Use BoxFit.contain to avoid cutting off the image
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              game.title,
              style: TextStyle(color: Colors.white, fontSize: 16), // Adjusted font size
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
