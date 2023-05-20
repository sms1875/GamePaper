class Wallpaper {
  final int page;
  final List<List<String>> pageUrlsList;
  final List<Map<String, String>> wallpapers;

  Wallpaper({
    required this.page,
    required this.pageUrlsList,
    required this.wallpapers,
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    final int page = json['page'];
    final pageUrlsList = json['pageUrls'] as List<List<String>>;
    final wallpapers = json['wallpapers'] as List<Map<String, String>>;
    return Wallpaper(
      page: page,
      pageUrlsList: pageUrlsList,
      wallpapers: wallpapers,
    );
  }
}
