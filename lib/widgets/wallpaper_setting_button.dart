import 'package:flutter/material.dart';
import 'package:async_wallpaper/async_wallpaper.dart';

/// 배경화면 설정 버튼을 포함하는 위젯입니다.
///
/// 이 위젯은 사용자에게 배경화면을 홈 화면, 잠금 화면, 또는 두 화면 모두로 설정할 수 있는 버튼을 제공합니다.
/// [imageUrl]은 배경화면으로 사용할 이미지의 URL입니다.
class WallpaperSettingButton extends StatelessWidget {
  /// 배경화면으로 사용할 이미지의 URL입니다.
  final String imageUrl;

  /// 생성자
  const WallpaperSettingButton({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildWallpaperButton(
            context,
            Icons.home,
            '홈 화면으로 설정',
                () => _setWallpaper(context, AsyncWallpaper.HOME_SCREEN),
          ),
          _buildWallpaperButton(
            context,
            Icons.lock,
            '잠금 화면으로 설정',
                () => _setWallpaper(context, AsyncWallpaper.LOCK_SCREEN),
          ),
          _buildWallpaperButton(
            context,
            Icons.smartphone,
            '두 화면 모두 설정',
                () => _setWallpaper(context, AsyncWallpaper.BOTH_SCREENS),
          ),
        ],
      ),
    );
  }

  /// 배경화면 설정 버튼을 생성합니다.
  ///
  /// [context]는 현재 빌드 컨텍스트입니다.
  /// [icon]은 버튼에 표시할 아이콘입니다.
  /// [tooltip]은 버튼에 대한 툴팁 텍스트입니다.
  /// [onPressed]는 버튼이 눌렸을 때 호출될 콜백입니다.
  Widget _buildWallpaperButton(
      BuildContext context,
      IconData icon,
      String tooltip,
      VoidCallback onPressed,
      ) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 36.0,
        ),
      ),
    );
  }

  /// 배경화면을 설정합니다.
  ///
  /// [context]는 현재 빌드 컨텍스트입니다.
  /// [wallpaperType]은 설정할 배경화면의 유형을 나타냅니다.
  Future<void> _setWallpaper(BuildContext context, int wallpaperType) async {
    try {
      final bool result = await AsyncWallpaper.setWallpaper(
        url: imageUrl,
        wallpaperLocation: wallpaperType,
      );
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('배경화면이 성공적으로 설정되었습니다!')),
        );
      } else {
        throw Exception('배경화면 설정 실패');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('배경화면 설정에 실패했습니다.')),
      );
    }
  }
}
