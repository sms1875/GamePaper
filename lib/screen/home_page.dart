import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/notifier/wallpaper_notifier.dart';
import 'package:wallpaper/screen/image_list_paging_widget.dart';
import 'package:wallpaper/screen/image_list_widget.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ImageListWidget(),
          ),
          Consumer<WallpaperNotifier>(
            builder: (_, notifier, __) {
              return const ImageListPagingWidget();
            },
          ),
        ],
      ),
    );
  }
}
