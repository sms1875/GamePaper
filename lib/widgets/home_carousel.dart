import 'package:flutter/material.dart';
import 'package:wallpaper/models/game.dart';
import 'package:wallpaper/widgets/carousel_item.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

class HomeCarousel extends StatelessWidget {
  final List<Game> games;
  final Function(Game) onGameTap;

  const HomeCarousel({
    Key? key,
    required this.games,
    required this.onGameTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool enableInfiniteScroll = games.length > 3;

    return CarouselSlider(
      options: CarouselOptions(
        height: screenHeight / 2, // Set height to half of the screen height
        enableInfiniteScroll: enableInfiniteScroll,
        viewportFraction: 0.6, // Adjust viewport fraction if needed
        enlargeCenterPage: true,
        enlargeFactor: 0.45, // Increase this value for a more dramatic effect
      ),
      items: games.map((game) => CarouselItem(
        game: game,
        onTap: () => onGameTap(game),
      )).toList(),
    );
  }
}
