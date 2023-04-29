import 'package:wallpaper/screen/image_list_paging_widget.dart';
import 'dart:io';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/notifier/wallpaper_notifier.dart';

class BlackDesertWallpaperScreen extends StatelessWidget {
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
      body: Consumer<WallpaperNotifier>(
        builder: (_, notifier, __) {
          if (notifier.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            final isPlatformSupported = Platform.isAndroid || Platform.isIOS;
            final wallpapers = notifier.imageList.wallpapers;
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 9 / 16,
                    ),
                    itemCount: wallpapers.length,
                    itemBuilder: (context, index) {
                      final wallpaper = wallpapers[index];
                      var url = isPlatformSupported ? wallpaper['attr-img_m'] : wallpaper['attr-img'];
                      if (!url!.startsWith('http')) {
                        url=wallpaper['src'];
                      }
                      return Card(
                        child: Column(
                          children: [
                            Expanded(child: Image.network(url!)),
                            if (isPlatformSupported)
                              url==wallpaper['src'] ? Text("모바일은 지원하지 않습니다"):_isPlatformSupportedWidget(wallpaper: url),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ImageListPagingWidget(),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _isPlatformSupportedWidget({required String wallpaper}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async{
            final result = await AsyncWallpaper.setWallpaper(url: wallpaper, wallpaperLocation:AsyncWallpaper.LOCK_SCREEN);
            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Text(result
                    ? '잠금화면이 성공적으로 설정되었습니다!'
                    : '잠금화면 설정에 실패했습니다.'),
              ),
            );
          },
          child: Text('잠금화면'),
        ),
        ElevatedButton(
          onPressed: () async{
            final result = await AsyncWallpaper.setWallpaper(url: wallpaper, wallpaperLocation:AsyncWallpaper.HOME_SCREEN);
            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Text(result
                    ? '배경화면이 성공적으로 설정되었습니다!'
                    : '배경화면 설정에 실패했습니다.'),
              ),
            );
          },
          child: Text('배경화면'),
        ),
      ],
    );
  }
}