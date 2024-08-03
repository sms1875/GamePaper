import 'package:flutter/material.dart';
import 'package:wallpaper/models/game.dart';
import 'package:wallpaper/screens/wallpaper_screen.dart';
import 'package:wallpaper/providers/wallpaper_provider_factory.dart';
import '../repository/wallpaper_repository_builder.dart';
import 'package:wallpaper/utils/load_network_image.dart';

/// GameCarouselItem 위젯
///
/// 이 위젯은 GameCarousel 내의 각 게임 항목을 표시합니다.
/// 게임 이미지와 제목을 포함하며, 탭하면 해당 게임의 월페이퍼 화면으로 이동합니다.
///
/// [game]: 표시할 게임 정보
class GameCarouselItem extends StatelessWidget {
  final Game game;

  const GameCarouselItem({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToWallpaperScreen(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: loadNetworkImage(
              game.image,
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

  /// 월페이퍼 화면으로 이동하는 메서드
  ///
  /// [context]: 현재 빌드 컨텍스트
  void _navigateToWallpaperScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WallpaperScreen(
          wallpaperProvider: WallpaperProviderFactory.createProvider(
            WallpaperRepositoryBuilder().fromData(game.repository).build(),
          ),
        ),
      ),
    );
  }
}