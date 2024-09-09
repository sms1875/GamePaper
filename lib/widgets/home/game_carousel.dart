import 'package:flutter/material.dart';
import 'package:gamepaper/models/game.dart';
import 'package:gamepaper/screens/wallpaper_screen.dart';
import 'package:gamepaper/widgets/common/load_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

class GameCarousel extends StatelessWidget {
  final List<Game> games;

  const GameCarousel({Key? key, required this.games}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: games.length,
      itemBuilder: (context, index, realIndex) {
        return _buildCarouselItem(context, games[index]);
      },
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height / 2,
        enableInfiniteScroll: games.length > 3,
        viewportFraction: 0.6,
        enlargeCenterPage: true,
        enlargeFactor: 0.45,
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, Game game) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.05;

    return GestureDetector(
      onTap: () => _navigateToWallpaperScreen(context, game),
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Stack(
          fit: StackFit.expand,
          children: [
            loadNetworkImage(
              game.thumbnail.url,
              blurHash: game.thumbnail.blurHash,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                color: Colors.black.withOpacity(0.7),
                child: Text(
                  game.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToWallpaperScreen(BuildContext context, Game game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WallpaperScreen(game: game),
      ),
    );
  }
}