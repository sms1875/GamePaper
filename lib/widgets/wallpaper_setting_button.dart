import 'package:flutter/material.dart';
import 'package:async_wallpaper/async_wallpaper.dart';

class WallpaperSettingButton extends StatelessWidget {
  final String imageUrl;

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
            'Set as Home Screen',
                () => _setWallpaper(context, AsyncWallpaper.HOME_SCREEN),
          ),
          _buildWallpaperButton(
            context,
            Icons.lock,
            'Set as Lock Screen',
                () => _setWallpaper(context, AsyncWallpaper.LOCK_SCREEN),
          ),
          _buildWallpaperButton(
            context,
            Icons.smartphone,
            'Set Both',
                () => _setWallpaper(context, AsyncWallpaper.BOTH_SCREENS),
          ),
        ],
      ),
    );
  }

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

  Future<void> _setWallpaper(BuildContext context, int wallpaperType) async {
    try {
      final result = await AsyncWallpaper.setWallpaper(
        url: imageUrl,
        wallpaperLocation: wallpaperType,
      );
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wallpaper set successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to set wallpaper.')),
      );
    }
  }
}