class Wallpaper {
  final int page;
  final List<String> pageUrls;
  final List<Map<String, String>> wallpapers;

  Wallpaper({
    required this.page,
    required this.pageUrls,
    required this.wallpapers,
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    final page = json['page'] as int;
    final pageUrls = json['pageUrls'] as List<String>;
    final wallpapers = json['wallpapers'] as List<Map<String, String>>;
    return Wallpaper(
      page: page,
      pageUrls: pageUrls,
      wallpapers: wallpapers,
    );
  }
}