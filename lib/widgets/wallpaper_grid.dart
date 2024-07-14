import 'package:flutter/material.dart';
import 'package:wallpaper/widgets/wallpaper_card.dart';

class WallpaperGrid extends StatelessWidget {
  final List<String> wallpapers;
  final ScrollController scrollController;

  const WallpaperGrid({
    Key? key,
    required this.wallpapers,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 9 / 16,
      ),
      itemCount: wallpapers.length,
      itemBuilder: (context, index) {
        return WallpaperCard(imageUrl: wallpapers[index]);
      },
      controller: scrollController,
    );
  }
}