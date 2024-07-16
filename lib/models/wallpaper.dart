class Wallpaper {
  final List<int> page;
  final List<String> pageUrlsList;
  final List<List<String>> wallpapers;

  Wallpaper({
    required this.page,
    required this.pageUrlsList,
    required this.wallpapers,
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    final List<int> page = List<int>.from(json['page']);
    final List<String> pageUrlsList = List<String>.from(json['pageUrls']);
    final List<List<String>> wallpapers = (json['wallpapers'] as List)
        .map((list) => List<String>.from(list))
        .toList();
    return Wallpaper(
      page: page,
      pageUrlsList: pageUrlsList,
      wallpapers: wallpapers,
    );
  }
}