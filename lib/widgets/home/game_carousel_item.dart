import 'package:flutter/material.dart';
import 'package:gamepaper/models/game.dart';
import 'package:gamepaper/screens/wallpaper_screen.dart';
import 'package:gamepaper/widgets/common/load_network_image.dart';

class GameCarouselItem extends StatelessWidget {
  final Game game;

  const GameCarouselItem({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // MediaQuery를 사용하여 화면 크기에 따른 폰트 크기와 패딩 조정
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth * 0.05; // 화면 너비의 5%로 폰트 크기 동적 조정

    return InkWell(
      onTap: () => _navigateToWallpaperScreen(context),
      child: AspectRatio(
        aspectRatio: 9 / 16, // 9:16 비율 유지
        child: Stack(
          children: [
            // 게임 썸네일 이미지
            Positioned.fill(
              child: loadNetworkImage(
                game.thumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
            // 이미지 하단에 게임 제목 오버레이
            Positioned(
              bottom: 0, // 이미지 하단에 배치
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                color: Colors.black.withOpacity(0.7), // 투명도 약간 증가
                child: Text(
                  game.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize, // 화면 크기에 따라 폰트 크기 동적으로 설정
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0), // 그림자 효과로 텍스트 가독성 증가
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2, // 긴 제목은 두 줄로 표시
                  overflow: TextOverflow.ellipsis, // 긴 제목은 말줄임 표시
                ),
              ),
            ),
          ],
        ),
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
