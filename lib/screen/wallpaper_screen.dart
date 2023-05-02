import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/provider/wallpaper_provider.dart';

mixin WallpaperScreen<T extends StatefulWidget> on State<T> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
                          child: wallPaperImage(url)),
                    ),
                  );
                },
                child: wallPaperImage(url)),
          ),
          isMobileUnSupported
              ? const Text("모바일은 지원하지 않습니다.")
              : buildPlatformWidget(url)
        ],
      ),
    );
  }

  Widget buildPageNumbers(
      List<int> pageNumbers, int currentPage, WallpaperProvider provider) {
    final wallpaperProvider = provider;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage == 1 ? null : () async {
            wallpaperProvider.prevPage();
            scrollController.jumpTo(0);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Row(
          children: [
            ...pageNumbers.map((i) => GestureDetector(
              onTap: () async {
                await wallpaperProvider.fetchPage(i);
                scrollController.jumpTo(0);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$i',
                  style: TextStyle(
                    color: currentPage == i ? Colors.blue : Colors.black,
                    fontWeight: currentPage == i
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 20,
                  ),
                ),
              ),
            )),
          ],
        ),
        IconButton(
          onPressed: currentPage == pageNumbers.length ? null : () async {
            wallpaperProvider.nextPage();
            scrollController.jumpTo(0);
          },
          icon: const Icon(Icons.arrow_forward_ios),
        ),
      ],
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
        buildWallpaperButton(wallpaper, '잠금 화면'),
        buildWallpaperButton(wallpaper, '홈 화면'),
      ],
    );
  }

  Widget buildWallpaperButton(String wallpaper, String text) {
    return ElevatedButton(
      onPressed: () async {
        String result = 'Loading';
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Loading'),
              content: LinearProgressIndicator(),
            );
          },
        );
        try {
          await AsyncWallpaper.setWallpaper(
            url: wallpaper,
            wallpaperLocation: text == '잠금 화면'
                ? AsyncWallpaper.LOCK_SCREEN
                : AsyncWallpaper.HOME_SCREEN,
          );
          result = '$text이 설정되었습니다';
        } catch (e) {
          result = '$text 설정에 실패했습니다';
        }
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(result),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      },
      child: Text(text),
    );
  }

  Widget buildPlatformDesktopWidget(String wallpaper) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [Text("데스크탑은 준비중입니다")],
    );
  }
}
