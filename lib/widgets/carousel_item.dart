import 'package:flutter/material.dart';
import 'package:wallpaper/models/game.dart';
import 'package:wallpaper/utils/load_network_image.dart';

/// 캐러셀 항목을 표시하는 위젯입니다.
///
/// 이 위젯은 게임의 이미지를 보여주며, 사용자가 이미지를 탭할 수 있도록 합니다.
/// [game]은 표시할 게임 정보를 포함하고 있으며, [onTap]은 사용자가 이미지를 탭했을 때 호출되는 콜백입니다.
class CarouselItem extends StatelessWidget {
  /// 게임 정보와 탭 이벤트를 처리하는 콜백을 포함하는 생성자입니다.
  final Game game;
  final VoidCallback onTap;

  /// 생성자
  const CarouselItem({
    Key? key,
    required this.game,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCarouselImage(),
          const SizedBox(height: 8),
          _buildCarouselText(),
        ],
      ),
    );
  }

  /// 캐러셀의 이미지를 빌드합니다.
  ///
  /// [BoxFit.contain]으로 이미지가 잘리지 않도록 설정합니다.
  Widget _buildCarouselImage() {
    return Expanded(
      child: loadNetworkImage(
        game.image,
        fit: BoxFit.contain, // 이미지가 잘리지 않도록 설정
      ),
    );
  }

  /// 캐러셀의 텍스트를 빌드합니다.
  ///
  /// 텍스트는 중앙 정렬되며, 최대 두 줄로 표시됩니다. 넘치는 텍스트는 생략됩니다.
  Widget _buildCarouselText() {
    return Text(
      game.title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16, // 텍스트의 폰트 크기
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis, // 텍스트가 길어질 경우 생략
    );
  }
}
