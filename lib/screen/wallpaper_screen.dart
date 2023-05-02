import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/provider/df_wallpaper_provider.dart';

mixin WallpaperScreen<T extends StatefulWidget> on State<T> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //build에서 호출하는 월페이퍼 위젯
  Widget buildWallpaperWidget(int currentPage,
      List<Map<String, String>> wallpapers, List<int> pageNumbers) {
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
                  var url = wallpaper['src']!;
                  return buildCardWidget(url);
                },
                controller: _scrollController),
          ),
          _buildPageNumbers(pageNumbers, currentPage, context)
        ],
      ),
    );
  }

  //각 월페이퍼 카드 위젯
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

  //월페이퍼 페이지
  Widget _buildPageNumbers(
      List<int> pageNumbers, int currentPage, BuildContext context) {
    final notifier = Provider.of<DungeonAndFighterWallpaperProvider>(context);
    final pageUrlsList = notifier.wallpaperPage.pageUrlsList;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage == 1
              ? null
              : () async {
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
              ? null
              : () async {
            notifier.nextPage();
            _scrollController.jumpTo(0);
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
