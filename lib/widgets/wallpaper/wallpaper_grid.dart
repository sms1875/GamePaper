import 'package:flutter/material.dart';
import 'package:gamepaper/widgets/wallpaper/wallpaper_card.dart';

/// WallpaperGrid 클래스는 배경화면 이미지를 그리드 형태로 표시합니다.
/// GridView를 사용하여 이미지를 효율적으로 표시하며, 각 이미지는 WallpaperCard로 렌더링됩니다.
class WallpaperGrid extends StatelessWidget {
  /// 배경화면 이미지 URL 리스트
  final List<String> wallpapers;

  /// WallpaperGrid 생성자
  /// [wallpapers]는 배경화면 이미지 URL 리스트입니다.
  const WallpaperGrid({
    super.key,
    required this.wallpapers,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 가로로 3개의 항목을 표시합니다.
        childAspectRatio: 9 / 16, // 항목의 가로:세로 비율을 9:16으로 설정합니다.
      ),
      itemCount: wallpapers.length, // 표시할 항목의 총 개수입니다.
      itemBuilder: (context, index) {
        // 각 항목을 WallpaperCard로 렌더링합니다.
        return WallpaperCard(
          imageUrl: wallpapers[index], // 각 항목의 이미지 URL입니다.
        );
      },
    );
  }
}
