import 'package:flutter/material.dart';
import 'package:wallpaper/widgets/common/load_network_image.dart';
import 'package:wallpaper/widgets/wallpaper/wallpaper_setting_button.dart';

/// 배경화면을 전체 화면으로 보여주는 다이얼로그입니다.
///
/// 이 다이얼로그는 배경화면 이미지를 표시하며, 사용자가 배경화면을 설정할 수 있는 버튼을 제공합니다.
/// [imageUrl]은 표시할 배경화면 이미지의 URL입니다.
class WallpaperDialog extends StatelessWidget {
  /// 배경화면 이미지의 URL입니다.
  final String imageUrl;

  /// 생성자
  const WallpaperDialog({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildImageBackground(context),
          _buildSettingButton(),
        ],
      ),
    );
  }

  /// 배경화면 이미지를 표시하는 위젯을 생성합니다.
  ///
  /// [context]는 현재 빌드 컨텍스트입니다.
  /// 이 위젯은 이미지를 클릭하면 다이얼로그를 닫습니다.
  Widget _buildImageBackground(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child:loadNetworkImage(
        imageUrl,
        fit: BoxFit.cover,
        errorWidget: const Icon(Icons.error), // 로딩 실패 시 오류 아이콘 표시
      ),
    );
  }

  /// 배경화면 설정 버튼을 포함하는 위젯을 생성합니다.
  ///
  /// 이 위젯은 다이얼로그의 하단에 배경화면 설정 버튼을 표시합니다.
  Widget _buildSettingButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.2,
        child: WallpaperSettingButton(imageUrl: imageUrl),
      ),
    );
  }
}
