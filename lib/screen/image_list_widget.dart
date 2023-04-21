import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/notifier/wallpaper_notifier.dart';

class ImageListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WallpaperNotifier>(
      builder: (_, notifier, __) {
        if (notifier.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final wallpapers = notifier.imageList.wallpapers;
          final pageUrls = notifier.imageList.pageUrls;

          return ListView.builder(
            itemCount: wallpapers.length,
            itemBuilder: (context, index) {
              final wallpaper = wallpapers[index];
              return Card(
                child: Column(
                  children: [
                    Image.network(wallpaper['src']!),
                    Text(wallpaper['attr-idx']!),
                    Text(wallpaper['attr-img']!),
                    Text(wallpaper['attr-img_m']!),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
