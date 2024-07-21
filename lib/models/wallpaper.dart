class Wallpaper {
  final List<int> pageNumbers;
  final List<String> pageUrls;
  final List<List<String>> wallpapersByPage;

  Wallpaper({
    required this.pageNumbers,
    required this.pageUrls,
    required this.wallpapersByPage,
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    final List<int> page = List<int>.from(json['page']);
    final List<String> pageUrlsList = List<String>.from(json['pageUrls']);
    final List<List<String>> wallpapers = (json['wallpapers'] as List)
        .map((list) => List<String>.from(list))
        .toList();
    return Wallpaper(
      pageNumbers: page,
      pageUrls: pageUrlsList,
      wallpapersByPage: wallpapers,
    );
  }
}