import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/provider/wallpaper_provider.dart';

abstract class AbstractWallpaperScreen extends StatefulWidget {
  final WallpaperProvider wallpaperProvider;

  const AbstractWallpaperScreen({super.key, required this.wallpaperProvider});

  @override
  State<StatefulWidget> createState() => _AbstractWallpaperScreenState();
}

class _AbstractWallpaperScreenState extends State<AbstractWallpaperScreen> {
  final scrollController = ScrollController();
  late WallpaperProvider wallpaperProvider;

  @override
  void initState() {
    super.initState();
    wallpaperProvider = widget.wallpaperProvider;
    wallpaperProvider.update(); //페이지 업데이트
    wallpaperProvider.addListener(updatePageNumbers); // 페이지 번호 갱신을 위해 리스너 추가
  }

  @override
  void dispose() {
    scrollController.dispose();
    wallpaperProvider.removeListener(updatePageNumbers); // 리스너 제거
    super.dispose();
  }

  void updatePageNumbers() {
    setState(() {}); // 상태 변경을 통해 build 메서드 호출
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = wallpaperProvider.isLoading;
    final error = wallpaperProvider.error;
    final currentPage = wallpaperProvider.currentPageIndex;
    final pageNumbers = wallpaperProvider.pageNumbers;
    final wallpapers = wallpaperProvider.wallpaperPage.wallpapers;

    return Scaffold(
      body: error != null
          ? buildErrorScreen()
          : Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 9 / 16,
              ),
              itemCount: wallpapers.length,
              itemBuilder: (context, index) {
                final wallpaper = wallpapers[index];
                final url = wallpaper['src']!;
                return buildWallpaperCard(url);
              },
              controller: scrollController,
            ),
          ),
          buildPageNumbers(pageNumbers, currentPage, wallpaperProvider),
        ],
      ),
    );
  }

  Widget buildWallpaperImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget buildWallpaperCard(String url) {
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
          buildWallpaperSettingBtnWidget(url),
        ],
      ),
    );
  }

  Widget buildPageNumbers(List<int> pageNumbers, int currentPage, WallpaperProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage == 1 ? null : () async {
            if (!provider.isLoading) {
              provider.prevPage();
              scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              await Future.delayed(const Duration(seconds: 2));
              provider.setLoading(false);
            }
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Row(children: pageNumbers.length < 9 ? List.generate(pageNumbers.length, (index) {
          final page = pageNumbers[index];
          return GestureDetector(
            onTap: () async {
              if (!provider.isLoading) {
                await provider.getPage(page);
                scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                await Future.delayed(const Duration(seconds: 2));
                provider.setLoading(false);
              }
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
        })
            : buildPageNumber(currentPage, pageNumbers, provider),
        ),
        IconButton(
          onPressed: currentPage == pageNumbers.length ? null : () async {
            if (!provider.isLoading) {
              provider.nextPage();
              scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              await Future.delayed(const Duration(seconds: 2));
              provider.setLoading(false);
            }
          },
          icon: const Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }

  List<Widget> buildPageNumber(int currentPage, List<int> pageNumbers, WallpaperProvider provider){
    List<Widget> gestureDetectors = [];

    int startingPage;
    int endingPage;

    if (currentPage <= 3) {    //1 2 3 4 5 ....
      startingPage = 1;
      endingPage = 5;
    } else if (currentPage >= pageNumbers.length - 2) { // 1 ... 6 7 8 9 10
      startingPage = pageNumbers.length - 4;
      endingPage = pageNumbers.length;
    } else {
      startingPage = currentPage - 2;  // ... 6 7 8 9 10  ...
      endingPage = currentPage + 2;
    }

    final List<int> displayedPageNumbers = List<int>.generate(endingPage - startingPage + 1, (index) => startingPage + index);

    if (startingPage > 1) {
      gestureDetectors.add(GestureDetector(
        onTap: () async {
          if (!provider.isLoading) {
            await provider.getPage(1);
            scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
            await Future.delayed(const Duration(seconds: 2));
            provider.setLoading(false);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '1',
            style: TextStyle(
              color: currentPage == 1 ? Colors.blue : Colors.black,
              fontWeight: currentPage == 1 ? FontWeight.bold : FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ),
      ));
      if (startingPage > 2) {
        gestureDetectors.add(const Text('...'));
      }
    }

    for (int i = 0; i < displayedPageNumbers.length; i++) {
      final page = displayedPageNumbers[i];
      gestureDetectors.add(GestureDetector(
        onTap: () async {
          if (!provider.isLoading) {
            await provider.getPage(page);
            scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
            await Future.delayed(const Duration(seconds: 2));
            provider.setLoading(false);
          }
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
      ));
    }

    if (endingPage < pageNumbers.length) {
      if (endingPage < pageNumbers.length - 1) {
        gestureDetectors.add(const Text('...'));
      }

      gestureDetectors.add(GestureDetector(
        onTap: () async {
          if (!provider.isLoading) {
            await provider.getPage(pageNumbers.length);
            scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
            await Future.delayed(const Duration(seconds: 2));
            provider.setLoading(false);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${pageNumbers.length}',
            style: TextStyle(
              color: currentPage == pageNumbers.length ? Colors.blue : Colors.black,
              fontWeight: currentPage == pageNumbers.length ? FontWeight.bold : FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ),
      ));
    }
    return gestureDetectors;
  }

  Widget buildWallpaperSettingBtnWidget(String wallpaper) {
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

  Widget buildErrorScreen() {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.close, color: Colors.white, size: 60),
            SizedBox(height: 20),
            Text("지금은 사용할 수 없습니다 \n 잠시후 다시 시도해주세요", style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
