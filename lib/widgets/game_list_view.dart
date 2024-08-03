import 'package:flutter/material.dart';
import 'package:wallpaper/models/game.dart';
import 'package:wallpaper/providers/wallpaper_provider.dart';
import 'package:wallpaper/repository/wallpaper_repository.dart';
import 'package:wallpaper/screens/wallpaper_screen.dart';

/// GameListView 위젯
///
/// 이 위젯은 게임 목록을 세로로 나열하여 표시합니다.
/// 각 게임 항목은 탭 가능하며, 탭하면 해당 게임의 월페이퍼 화면으로 이동합니다.
///
/// [games]: 표시할 게임 목록
class GameListView extends StatelessWidget {
  final List<Game> games;

  const GameListView({Key? key, required this.games}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: games.map((game) => InkWell(
        onTap: () => _navigateToWallpaperScreen(context, game),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            game.title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      )).toList(),
    );
  }

  /// 월페이퍼 화면으로 이동하는 메서드
  ///
  /// [context]: 현재 빌드 컨텍스트
  /// [game]: 선택된 게임
  void _navigateToWallpaperScreen(BuildContext context, Game game) {
    final wallpaperProvider = WallpaperProvider(
        WallpaperRepository()
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WallpaperScreen(
          wallpaperProvider: wallpaperProvider,
        ),
      ),
    );
  }
}