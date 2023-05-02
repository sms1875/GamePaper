import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/notifier/blackdesert_wallpaper_notifier.dart';

class BlackDesertWallpaperScreen extends StatefulWidget {

  @override
  State<BlackDesertWallpaperScreen> createState() => _BlackDesertWallpaperScreenState();
}

class _BlackDesertWallpaperScreenState extends State<BlackDesertWallpaperScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<BlackDesertWallpaperNotifier>();
    final currentPage = notifier.currentPageIndex;
    final wallpapers = notifier.wallpaperPage.wallpapers;
    final pageNumbers = List.generate(
        notifier.wallpaperPage.pageUrls.length, (index) => index + 1);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 9 / 16,
              ),
              itemCount: wallpapers.length,
              itemBuilder: (context, index) {
                final wallpaper = wallpapers[index];
                var url = Theme.of(context).platform == TargetPlatform.android || Theme.of(context).platform == TargetPlatform.iOS
                    ? wallpaper['attr-img_m']
                    : wallpaper['attr-img'];
                //모바일이 지원 안되는 월페이퍼 구분
                if (!url!.startsWith('http')) {
                  url = wallpaper['src'];
                }
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
                                  child: _wallPaperImage(url!),
                                ),
                              ),
                            );
                          },
                          child: _wallPaperImage(url!),
                        ),
                      ),
                      url == wallpaper['src']
                          ? Text("모바일은 지원하지 않습니다.")
                          : _buildPlatformWidget(url),
                    ],
                  ),
                );
              },
              controller: _scrollController, // ScrollController 할당
            ),
          ),
          _buildPageNumbers(pageNumbers, currentPage, notifier),
        ],
      ),
    );
  }

  Widget _wallPaperImage(String url) {
    return Image.network(
      url,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  }

  Widget _buildPageNumbers(List<int> pageNumbers, int currentPage , BlackDesertWallpaperNotifier notifier) {
    final pageUrlsList = notifier.wallpaperPage.pageUrls;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage == 1 ? null : () async {
            notifier.prevPage();
            _scrollController.jumpTo(0);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Row(
          children: [
            ...pageNumbers.map((i) => GestureDetector(
              onTap: () async {
                await notifier.fetchImageListPage(i);
                _scrollController.jumpTo(0);
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
          onPressed: currentPage == pageUrlsList.length
              ? null : () async {
            notifier.nextPage();
            _scrollController.jumpTo(0);
          },
          icon: const Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }

  Widget _buildPlatformWidget(String wallpaper) {
    if (Theme.of(context).platform == TargetPlatform.android) {
      return _buildPlatformMobileWidget(wallpaper);
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      return _buildPlatformMobileWidget(wallpaper);
    } else {
      return _buildPlatformDesktopWidget(wallpaper);
    }
  }

  Widget _buildPlatformMobileWidget(String wallpaper) {
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

  Widget _buildPlatformDesktopWidget(String wallpaper) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [Text("데스크탑은 준비중입니다")],
    );
  }
}