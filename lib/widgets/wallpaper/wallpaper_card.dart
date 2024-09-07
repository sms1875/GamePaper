import 'package:flutter/material.dart';
import 'package:gamepaper/widgets/wallpaper/wallpaper_dialog.dart';
import 'package:gamepaper/widgets/common/load_network_image.dart';

/// 배경화면을 카드 형태로 표시하는 위젯입니다.
///
/// 이 위젯은 배경화면 이미지를 카드로 보여주며, 사용자가 이미지를 탭하면
/// 전체 화면으로 배경화면을 볼 수 있는 다이얼로그를 표시합니다.
/// [imageUrl]은 카드에 표시될 배경화면 이미지의 URL입니다.
class WallpaperCard extends StatelessWidget {
  /// 카드에 표시할 배경화면 이미지의 URL입니다.
  final String imageUrl;

  /// 생성자
  const WallpaperCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: const EdgeInsets.all(1),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _showWallpaperDialog(context),
        child: _buildImage(),
      ),
    );
  }

  /// 배경화면 이미지를 표시하는 위젯을 생성합니다.
  ///
  /// 이 위젯은 `loadNetworkImage` 함수를 사용하여 이미지를 로드하고,
  /// 로딩 중 스피너와 오류 아이콘을 표시합니다.
  Widget _buildImage() {
    return loadNetworkImage(
      imageUrl,
      fit: BoxFit.cover,
      errorWidget: const Icon(Icons.error), // 로딩 실패 시 오류 아이콘 표시
    );
  }

  /// 배경화면 다이얼로그를 표시합니다.
  ///
  /// [context]는 현재 빌드 컨텍스트입니다.
  /// 이 메서드는 전체 화면으로 배경화면을 보여주는 다이얼로그를 표시합니다.
  void _showWallpaperDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => WallpaperDialog(imageUrl: imageUrl),
    );
  }
}
