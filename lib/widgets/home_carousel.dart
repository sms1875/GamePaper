import 'package:flutter/material.dart';
import 'package:wallpaper/models/game.dart';
import 'package:wallpaper/widgets/carousel_item.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

/// 홈 화면에 표시될 캐러셀 위젯입니다.
///
/// 이 위젯은 주어진 게임 목록을 사용하여 캐러셀을 생성합니다.
/// [games]는 캐러셀에 표시할 게임의 리스트이며, [onGameTap]은 사용자가 아이템을 탭할 때 호출되는 콜백입니다.
class HomeCarousel extends StatelessWidget {
  /// 게임 목록과 탭 이벤트를 처리하는 콜백을 포함하는 생성자입니다.
  final List<Game> games;
  final Function(Game) onGameTap;

  /// 생성자
  const HomeCarousel({
    Key? key,
    required this.games,
    required this.onGameTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: _buildCarouselOptions(context),
      items: games.map((game) => CarouselItem(
        game: game,
        onTap: () => onGameTap(game),
      )).toList(),
    );
  }

  /// 캐러셀 슬라이더의 옵션을 구성하는 메소드입니다.
  ///
  /// 화면 높이에 따라 캐러셀의 높이를 설정하고, 게임 리스트의 길이에 따라
  /// 무한 스크롤 여부를 결정합니다.
  CarouselOptions _buildCarouselOptions(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool enableInfiniteScroll = games.length > 3;

    return CarouselOptions(
      height: screenHeight / 2, // 화면 높이의 절반으로 캐러셀 높이 설정
      enableInfiniteScroll: enableInfiniteScroll, // 게임 수에 따라 무한 스크롤 설정
      viewportFraction: 0.6, // 캐러셀 아이템의 가시 영역 비율
      enlargeCenterPage: true, // 중앙 페이지 확대 설정
      enlargeFactor: 0.45, // 중앙 아이템의 확대 비율
    );
  }
}
