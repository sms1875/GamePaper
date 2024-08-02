import 'package:flutter/material.dart';
import 'package:wallpaper/widgets/wallpaper_card.dart';

/// 배경화면을 그리드 형식으로 표시하는 위젯입니다.
///
/// 이 위젯은 주어진 배경화면 목록을 그리드 형태로 표시하며, 스크롤 컨트롤러를 지원합니다.
class WallpaperGrid extends StatelessWidget {
  /// 배경화면 이미지 URL 목록입니다.
  final List<String> wallpapers;

  /// 스크롤을 제어하는 [ScrollController]입니다.
  final ScrollController scrollController;

  /// 생성자
  const WallpaperGrid({
    Key? key,
    required this.wallpapers,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: _buildGridDelegate(),
      itemCount: wallpapers.length,
      itemBuilder: (context, index) => WallpaperCard(imageUrl: wallpapers[index]),
      controller: scrollController,
    );
  }

  /// 그리드 레이아웃을 정의합니다.
  ///
  /// [SliverGridDelegateWithFixedCrossAxisCount]를 사용하여
  /// 고정된 열 수와 자식 비율을 설정합니다.
  SliverGridDelegate _buildGridDelegate() {
    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // 3개의 열
      childAspectRatio: 9 / 16, // 자식의 비율
    );
  }
}