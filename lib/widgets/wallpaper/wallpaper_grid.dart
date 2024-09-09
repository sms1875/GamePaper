import 'package:flutter/material.dart';
import 'package:gamepaper/widgets/wallpaper/wallpaper_card.dart';
import 'package:gamepaper/models/game.dart'; // Import the Wallpaper model

/// 배경화면을 그리드 형태로 보여주는 위젯입니다.
/// 주어진 [wallpapers] 리스트를 기반으로 각 배경화면을 표시합니다.
class WallpaperGrid extends StatelessWidget {
  final List<Wallpaper> wallpapers; // Change from List<String> to List<Wallpaper>

  const WallpaperGrid({
    super.key,
    required this.wallpapers,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = _getCrossAxisCount(screenWidth);

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 9 / 16,
      ),
      itemCount: wallpapers.length,
      itemBuilder: (context, index) {
        return WallpaperCard(wallpaper: wallpapers[index]); // Pass Wallpaper object
      },
    );
  }

  /// 화면 크기에 따라 그리드 열 개수를 조정
  int _getCrossAxisCount(double screenWidth) {
    if (screenWidth > 600) {
      return 4;
    } else if (screenWidth < 350) {
      return 2;
    }
    return 3;
  }
}
