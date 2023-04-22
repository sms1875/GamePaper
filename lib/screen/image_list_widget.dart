import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
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

          return ListView.builder(
            itemCount: wallpapers.length,
            itemBuilder: (context, index) {
              final wallpaper = wallpapers[index];
              return InkWell(
                onTap: () async {
                  // 배경화면 설정 코드
                },
                child: Card(
                  child: Column(
                    children: [
                      Image.network(wallpaper['src']!),
                      Text(wallpaper['attr-idx']!),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async{
                              if(Platform.isAndroid || Platform.isIOS){
                                final url = wallpaper['attr-img_m'] ?? wallpaper['attr-img'];
                                final result = await AsyncWallpaper.setWallpaper(url: url!,wallpaperLocation:AsyncWallpaper.LOCK_SCREEN);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result
                                        ? '잠금화면이 성공적으로 설정되었습니다!'
                                        : '잠금화면 설정에 실패했습니다.'),
                                  ),
                                );
                              }
                            },
                            child: Text('잠금화면'),
                          ),
                          ElevatedButton(
                            onPressed:  () async{
                              if(Platform.isAndroid || Platform.isIOS){
                                final url = wallpaper['attr-img_m'] ?? wallpaper['attr-img'];
                                final result = await AsyncWallpaper.setWallpaper(url: url!,wallpaperLocation:AsyncWallpaper.HOME_SCREEN);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result
                                        ? '배경화면이 성공적으로 설정되었습니다!'
                                        : '배경화면 설정에 실패했습니다.'),
                                  ),
                                );
                              }
                            },
                            child: Text('배경화면'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}