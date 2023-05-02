import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/notifier/df_wallpaper_notifier.dart';

mixin WallpaperScreen<T extends StatefulWidget> on State<T> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildCardWidget(String url, {bool isMobileUnSupported = false}) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: wallPaperImage(url)
                      ),
                    ),
                  );
                },
                child: wallPaperImage(url)
            ),
          ),
          isMobileUnSupported
              ? const Text("모바일은 지원하지 않습니다.")
              : buildPlatformWidget(url)
        ],
      ),
    );
  }

  Widget wallPaperImage(String url) {
    return Image.network(
      url,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  }

  Widget buildPlatformWidget(String wallpaper) {
    if (Theme.of(context).platform == TargetPlatform.android) {
      return buildPlatformMobileWidget(wallpaper);
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      return buildPlatformMobileWidget(wallpaper);
    } else {
      return buildPlatformDesktopWidget(wallpaper);
    }
  }

  Widget buildPlatformMobileWidget(String wallpaper) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            await AsyncWallpaper.setWallpaper(
              url: wallpaper,
              wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
              toastDetails: ToastDetails(message: '잠금 화면이 성공적으로 설정되었습니다!'),
              errorToastDetails: ToastDetails(message: '잠금 화면 설정에 실패했습니다.'),
            );
          },
          child: const Text('잠금 화면'),
        ),
        ElevatedButton(
          onPressed: () async {
            await AsyncWallpaper.setWallpaper(
              url: wallpaper,
              wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
              toastDetails: ToastDetails(message: '배경 화면이 성공적으로 설정되었습니다!'),
              errorToastDetails: ToastDetails(message: '배경 화면 설정에 실패했습니다.'),
            );
          },
          child: const Text('배경 화면'),
        ),
      ],
    );
  }

  Widget buildPlatformDesktopWidget(String wallpaper) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [Text("데스크탑은 준비중입니다")],
    );
  }
}