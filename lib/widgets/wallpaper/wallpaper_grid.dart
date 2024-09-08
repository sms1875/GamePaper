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
    // 화면 너비에 따라 그리드 항목의 갯수를 조정할 수 있습니다.
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 3; // 기본적으로 한 행에 3개의 항목을 표시

    if (screenWidth > 600) {
      crossAxisCount = 4; // 화면이 더 넓으면 4개의 항목 표시
    } else if (screenWidth < 350) {
      crossAxisCount = 2; // 화면이 좁으면 2개의 항목 표시
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount, // 한 행에 표시할 항목 개수
        crossAxisSpacing: 8.0, // 항목 간의 가로 간격
        mainAxisSpacing: 8.0, // 항목 간의 세로 간격
        childAspectRatio: 9 / 16, // 항목의 가로:세로 비율을 9:16으로 설정
      ),
      itemCount: wallpapers.length, // 총 항목 개수
      itemBuilder: (context, index) {
        // 각 항목을 WallpaperCard로 렌더링
        return WallpaperCard(
          imageUrl: wallpapers[index], // 각 항목의 이미지 URL
        );
      },
    );
  }
}
