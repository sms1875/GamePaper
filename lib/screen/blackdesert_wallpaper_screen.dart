import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/notifier/blackdesert_wallpaper_notifier.dart';
import 'package:wallpaper/screen/wallpaper_screen.dart';

class BlackDesertWallpaperScreen extends StatefulWidget {

  @override
  State<BlackDesertWallpaperScreen> createState() => _BlackDesertWallpaperScreenState();
}

class _BlackDesertWallpaperScreenState extends State<BlackDesertWallpaperScreen>  with WallpaperScreen {
  final _scrollController = ScrollController();

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
                return buildCardWidget(url!,isMobileUnSupported: url == wallpaper['src']);
              },
              controller: _scrollController,
            ),
          ),
          _buildPageNumbers(pageNumbers, currentPage, notifier),
        ],
      ),
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
}