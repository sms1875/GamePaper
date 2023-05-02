import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/provider/wallpaper_provider.dart';

mixin WallpaperMixin<T extends StatefulWidget> on State<T> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget buildWallpaperImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget buildWallpaperCard(String url, {bool isMobileUnSupported = false}) {
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
                      child: buildWallpaperImage(url),
                    ),
                  ),
                );
              },
              child: buildWallpaperImage(url),
            ),
          ),
          isMobileUnSupported
              ? const Text("모바일은 지원하지 않습니다.")
              : buildPlatformDependentWidget(url)
        ],
      ),
    );
  }

  Widget buildPageNumbers(
      List<int> pageNumbers, int currentPage, WallpaperProvider provider) {
    final gestureDetectors = List.generate(pageNumbers.length, (index) {
      final page = pageNumbers[index];
      return GestureDetector(
        onTap: () async {
          await provider.fetchPage(page);
          scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$page',
            style: TextStyle(
              color: currentPage == page ? Colors.blue : Colors.black,
              fontWeight: currentPage == page ? FontWeight.bold : FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ),
      );
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage == 1 ? null : () async {
            provider.prevPage();
            scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Row(
          children: gestureDetectors,
        ),
        IconButton(
          onPressed: currentPage == pageNumbers.length ? null : () async {
            provider.nextPage();
            scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
          icon: const Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }

  Widget buildPlatformDependentWidget(String wallpaper) {
    final currentPlatform = Theme.of(context).platform;
    if (currentPlatform == TargetPlatform.android) {
      return buildMobileWallpaperWidget(wallpaper);
    } else if (currentPlatform == TargetPlatform.iOS) {
      return buildMobileWallpaperWidget(wallpaper);
    } else {
      return buildDesktopWallpaperWidget(wallpaper);
    }
  }

  Widget buildMobileWallpaperWidget(String wallpaper) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildSetWallpaperButton(wallpaper, '잠금 화면'),
        buildSetWallpaperButton(wallpaper, '홈 화면'),
      ],
    );
  }

  Widget buildSetWallpaperButton(String wallpaper, String text) {
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
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(result),
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

  Widget buildDesktopWallpaperWidget(String wallpaper) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [Text("데스크탑은 준비중입니다")],
    );
  }
}
