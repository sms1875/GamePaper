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
                  await provider.fetchPage(page);
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
            await provider.fetchPage(1);
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
            await provider.fetchPage(page);
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
            await provider.fetchPage(pageNumbers.length);
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
