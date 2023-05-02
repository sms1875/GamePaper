import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/notifier/df_wallpaper_notifier.dart';
import 'package:wallpaper/screen/wallpaper_screen.dart';

class DungeonAndFighterWallpaperScreen extends StatefulWidget{

  @override
  State<DungeonAndFighterWallpaperScreen> createState() => _DungeonAndFighterWallpaperScreenState();
}

class _DungeonAndFighterWallpaperScreenState extends State<DungeonAndFighterWallpaperScreen> with WallpaperScreen {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<DungeonAndFighterWallpaperNotifier>();
    final currentPage = notifier.currentPageIndex;
    final wallpapers = notifier.wallpaperPage.wallpapers;
    final pageNumbers = List.generate(
        notifier.wallpaperPage.pageUrlsList.length, (index) => index + 1);

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
              controller: _scrollController
            ),
          ),
          _buildPageNumbers(pageNumbers, currentPage, notifier)
        ],
      ),
    );
  }

  Widget _buildPageNumbers(List<int> pageNumbers, int currentPage , DungeonAndFighterWallpaperNotifier notifier) {
    final pageUrlsList = notifier.wallpaperPage.pageUrlsList;

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