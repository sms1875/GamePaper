import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/notifier/wallpaper_notifier.dart';

class BlackDesertWallpaperScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final notifier = context.watch<WallpaperNotifier>();
    final pageUrls = notifier.imageList.pageUrls;
    final currentPage = notifier.currentPage;
    final isPlatformSupported = Platform.isAndroid || Platform.isIOS;
    final wallpapers = notifier.imageList.wallpapers;
    final pageNumbers = List.generate(pageUrls.length, (index) => index + 1);

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
                url = wallpaper['src'];
              }
              return Card(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(url!),
                    ),
                    if (isPlatformSupported)
                      url == wallpaper['src']
                          ? Text("모바일에서는 지원하지 않습니다.")
                          : _buildPlatformSupportedWidget(context, url),
                  ],
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: currentPage == 1 ? null : () => context.read<WallpaperNotifier>().prevPage(context.read()),
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final i in pageNumbers)
                      GestureDetector(
                        onTap: () => context.read<WallpaperNotifier>().fetchImageListPage(context.read(), i),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '$i',
                            style: TextStyle(
                              color: currentPage == i ? Colors.blue : Colors.black,
                              fontWeight: currentPage == i ? FontWeight.bold : FontWeight.normal,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: currentPage == pageUrls.length ? null : () => context.read<WallpaperNotifier>().nextPage(context.read()),
              icon: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildPlatformSupportedWidget(BuildContext context, String wallpaper) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            final result = await AsyncWallpaper.setWallpaper(
              url: wallpaper,
              wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  result
                      ? '잠금 화면이 성공적으로 설정되었습니다!'
                      : '잠금 화면 설정에 실패했습니다.',
                ),
              ),
            );
          },
          child: Text('잠금 화면'),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await AsyncWallpaper.setWallpaper(
              url: wallpaper,
              wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  result
                      ? '배경 화면이 성공적으로 설정되었습니다!'
                      : '배경 화면 설정에 실패했습니다.',
                ),
              ),
            );
          },
          child: Text('배경 화면'),
        ),
      ],
    );
  }
}