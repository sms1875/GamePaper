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
        child: Image.network(

          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){
          if(loadingProgress == null){
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
            ),
          );
        },
          errorBuilder: (context, url, error) => const Icon(Icons.error),
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