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
      child: Center(
        child: IconButton(
          onPressed: () => _setWallpaper(context),
          icon: const Icon(
            Icons.wallpaper,
            color: Colors.white,
            size: 36.0,
          ),
        ),
      ),
    );
  }

  Future<void> _setWallpaper(BuildContext context) async {
    try {
      final result = await AsyncWallpaper.setWallpaper(url: imageUrl);
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