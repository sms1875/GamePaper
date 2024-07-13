import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallpaper/widgets/wallpaper_dialog.dart';

class WallpaperCard extends StatelessWidget {
  final String imageUrl;

  const WallpaperCard({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: const EdgeInsets.all(1),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _showWallpaperDialog(context),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  void _showWallpaperDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => WallpaperDialog(imageUrl: imageUrl),
    );
  }
}