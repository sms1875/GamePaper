import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/provider/abstract_wallpaper_provider.dart';

abstract class AbstractWallpaperScreen extends StatefulWidget {
  final AbstractWallpaperProvider wallpaperProvider;

  const AbstractWallpaperScreen({super.key, required this.wallpaperProvider});

  @override
  State<StatefulWidget> createState() => _AbstractWallpaperScreenState();
}

class _AbstractWallpaperScreenState extends State<AbstractWallpaperScreen> {
  final scrollController = ScrollController();
  late AbstractWallpaperProvider wallpaperProvider;

  @override
  void initState() {
    super.initState();
    wallpaperProvider = widget.wallpaperProvider;
    // 페이지 업데이트
    wallpaperProvider.update();
    // 페이지 번호 갱신을 위해 리스너 추가
    wallpaperProvider.addListener(updatePageNumbers);
  }

  @override
  void dispose() {
    scrollController.dispose();
    // 리스너 제거
    wallpaperProvider.removeListener(updatePageNumbers);
    super.dispose();
  }

  void updatePageNumbers() {
    // 상태 변경을 통해 build 메서드 호출
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = wallpaperProvider.isLoading;
    final error = wallpaperProvider.error;
    final currentPage = wallpaperProvider.currentPageIndex;
    final pageNumbers = wallpaperProvider.pageNumbers;
    final wallpapers = wallpaperProvider.wallpaperPage.wallpapers;

    return Scaffold(
      backgroundColor: Colors.black,
      body: error != null
          ? buildErrorScreen()
          : Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 9 / 16,
              ),
              itemCount: wallpapers.length,
              itemBuilder: (context, index) {
                return buildWallpaperCard(wallpapers[index]['src']!);
              },
              controller: scrollController,
            ),
          ),
          buildPageNumbers(pageNumbers, currentPage, wallpaperProvider),
        ],
      ),
    );
  }

  Widget buildWallpaperCard(String url) {
    final wallpaperImage = CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );

    return Card(
      color: Colors.black,
      margin: const EdgeInsets.all(1),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                insetPadding: const EdgeInsets.all(0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: wallpaperImage,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        alignment: Alignment.topCenter,
                        heightFactor: 0.2,
                        child: buildWallpaperSettingBtnWidget(url),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: wallpaperImage,
      ),
    );
  }

  Widget buildPageNumbers(List<int> pageNumbers, int currentPage, AbstractWallpaperProvider provider) {
    return pageNumbers.isEmpty
        ? const SizedBox()
        : Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage == 1
              ? null
              : () async {
            if (!provider.isLoading) {
              provider.prevPage();
              scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              await Future.delayed(const Duration(seconds: 2));
              provider.setLoading(false);
            }
          },
          icon: currentPage == 1 || pageNumbers.isEmpty
              ? const Icon(Icons.arrow_back_ios, color: Colors.grey)
              : const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        Row(
          children: pageNumbers.length < 9
              ? List.generate(pageNumbers.length, (index) {
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
                    color: currentPage == page ? Colors.blue : Colors.white,
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
          onPressed: currentPage == pageNumbers.length
              ? null
              : () async {
            if (!provider.isLoading) {
              provider.nextPage();
              scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              await Future.delayed(const Duration(seconds: 2));
              provider.setLoading(false);
            }
          },
          icon: currentPage == pageNumbers.length || pageNumbers.isEmpty
              ? const Icon(Icons.arrow_forward_ios, color: Colors.grey)
              : const Icon(Icons.arrow_forward_ios, color: Colors.white),
        ),
      ],
    );
  }

  List<Widget> buildPageNumber(int currentPage, List<int> pageNumbers, AbstractWallpaperProvider provider) {
    List<Widget> gestureDetectors = [];

    int startingPage;
    int endingPage;

    if (currentPage <= 3) {
      startingPage = 1;
      endingPage = 5;
    } else if (currentPage >= pageNumbers.length - 2) {
      startingPage = pageNumbers.length - 4;
      endingPage = pageNumbers.length;
    } else {
      startingPage = currentPage - 2;
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
              color: currentPage == 1 ? Colors.blue : Colors.white,
              fontWeight: currentPage == 1 ? FontWeight.bold : FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ),
      ));
      if (startingPage > 2) {
        gestureDetectors.add(const Text('...', style: TextStyle(color: Colors.white)));
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
              color: currentPage == page ? Colors.blue : Colors.white,
              fontWeight: currentPage == page ? FontWeight.bold : FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ),
      ));
    }

    if (endingPage < pageNumbers.length) {
      if (endingPage < pageNumbers.length - 1) {
        gestureDetectors.add(const Text('...', style: TextStyle(color: Colors.white)));
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
              color: currentPage == pageNumbers.length ? Colors.blue : Colors.white,
              fontWeight: currentPage == pageNumbers.length ? FontWeight.bold : FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ),
      ));
    }

    return gestureDetectors;
  }

  Widget buildErrorScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          const Text(
            'An error occurred while fetching wallpapers.',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              wallpaperProvider.update();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget buildWallpaperSettingBtnWidget(String url) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Center(
        child: IconButton(
          onPressed: () async {
            try {
              final result = await AsyncWallpaper.setWallpaper(url: url);
              if (result) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Wallpaper set successfully!'),
                  ),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to set wallpaper.'),
                ),
              );
            }
          },
          icon: const Icon(
            Icons.wallpaper,
            color: Colors.white,
            size: 36.0,
          ),
        ),
      ),
    );
  }
}