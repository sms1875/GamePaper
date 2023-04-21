import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/notifier/wallpaper_notifier.dart';

class ImageListPagingWidget extends StatelessWidget {
  const ImageListPagingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<WallpaperNotifier>();
    final pageUrls = notifier.imageList.pageUrls;
    final currentPage = notifier.currentPage;

    List<int> pageNumbers = [];

    for (int i = 1; i <= pageUrls.length; i++) {
      pageNumbers.add(i);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage == 1 ? null : () => notifier.prevPage(context.read()),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i in pageNumbers)
                  GestureDetector(
                    onTap: () => notifier.fetchImageListPage(context.read(), i),
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
                  ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: currentPage == pageUrls.length ? null : () => notifier.nextPage(context.read()),
          icon: const Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }
}