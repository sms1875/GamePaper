import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/notifier/wallpaper_notifier.dart';

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
    final notifier = context.watch<WallpaperNotifier>();
    final pageUrls = notifier.imageList.pageUrls;
    final currentPage = notifier.currentPage;
    final isPlatformMobile = Platform.isAndroid || Platform.isIOS;
    final wallpapers = notifier.imageList.wallpapers;

    return Scaffold(
      body: Column(
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
                var url = isPlatformMobile ? wallpaper['attr-img_m'] : wallpaper['attr-img'];
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
                                  child: Image.network(url!),
                                ),
                              ),
                            );
                          },
                          child: Image.network(url!),
                        ),
                      ),
                      isPlatformMobile
                          ? url == wallpaper['src']
                          ? Text("모바일은 지원하지 않습니다.")
                          : _buildPlatformMobileWidget(context, url)
                          : _buildPlatformDesktopWidget(context, url),
                    ],
                  ),
                );
              },
              controller: _scrollController, // ScrollController 할당
            ),
          ),
          _buildPageNumbers(context, pageUrls, currentPage),
        ],
      ),
    );
  }

  Widget _buildPageNumbers(BuildContext context, List<String> pageUrls, int currentPage) {
    final pageNumbers = List.generate(pageUrls.length, (index) => index + 1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage == 1 ? null : () {
            context.read<WallpaperNotifier>().prevPage(context.read());
            _scrollController.jumpTo(0); // 스크롤 맨 위로 이동
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...pageNumbers.map((i) => GestureDetector(
                onTap: () {
                  context.read<WallpaperNotifier>().fetchImageListPage(context.read(), i);
                  _scrollController.jumpTo(0);
                  },
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
              )),
            ],
          ),
        ),
        IconButton(
          onPressed: currentPage == pageUrls.length ? null : () {
            context.read<WallpaperNotifier>().nextPage(context.read());
            _scrollController.jumpTo(0); // 스크롤 맨 위로 이동
          },
          icon: const Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }

  Widget _buildPlatformMobileWidget(BuildContext context, String wallpaper) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            final result = await AsyncWallpaper.setWallpaper(
              url: wallpaper,
              wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
              toastDetails: ToastDetails( message: '잠금 화면이 성공적으로 설정되었습니다!'),
              errorToastDetails: ToastDetails( message: '잠금 화면 설정에 실패했습니다.'),
            );
          },
          child: Text('잠금 화면'),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await AsyncWallpaper.setWallpaper(
              url: wallpaper,
              wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
              toastDetails: ToastDetails( message: '배경 화면이 성공적으로 설정되었습니다!'),
              errorToastDetails: ToastDetails( message: '배경 화면 설정에 실패했습니다.'),
            );
          },
          child: Text('배경 화면'),
        ),
      ],
    );
  }

  Widget _buildPlatformDesktopWidget(BuildContext context, String wallpaper) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("데스크탑은 준비중입니다")
      ],
    );
  }
}