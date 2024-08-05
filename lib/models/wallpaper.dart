import 'package:firebase_storage/firebase_storage.dart';

class Wallpaper {
  final List<int> pageNumbers;
  final List<List<String>> wallpapersByPage;

  Wallpaper({
    required this.pageNumbers,
    required this.wallpapersByPage,
  });

  factory Wallpaper.fromUrls(List<String> urls) {
    const int wallpapersPerPage = 12;
    final int totalPages = (urls.length / wallpapersPerPage).ceil();

    List<List<String>> wallpapersByPage = [];
    for (int i = 0; i < totalPages; i++) {
      final startIndex = i * wallpapersPerPage;
      final endIndex = (startIndex + wallpapersPerPage < urls.length)
          ? startIndex + wallpapersPerPage
          : urls.length;
      wallpapersByPage.add(urls.sublist(startIndex, endIndex));
    }

    return Wallpaper(
      pageNumbers: List.generate(totalPages, (index) => index + 1),
      wallpapersByPage: wallpapersByPage,
    );
  }
}