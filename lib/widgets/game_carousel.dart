import 'package:flutter/material.dart';
import 'package:wallpaper/models/game.dart';
import 'package:wallpaper/widgets/game_carousel_item.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

/// GameCarousel 위젯
///
/// 이 위젯은 게임 목록을 가로 스크롤 가능한 캐러셀 형태로 표시합니다.
/// [CarouselSlider]를 사용하여 구현되었습니다.
///
/// [games]: 캐러셀에 표시할 게임 목록
class GameCarousel extends StatelessWidget {
  final List<Game> games;

  const GameCarousel({Key? key, required this.games}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height / 2,
        enableInfiniteScroll: games.length > 3,
        viewportFraction: 0.6,
        enlargeCenterPage: true,
        enlargeFactor: 0.45,
      ),
      items: games.map((game) => GameCarouselItem(game: game)).toList(),
    );
  }
}