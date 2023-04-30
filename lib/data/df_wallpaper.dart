class DungeonAndFighterWallpaper {
  final int page;
  final List<List<String>> pageUrls;
  final List<Map<String, String>> wallpapers;

  DungeonAndFighterWallpaper({
    required this.page,
    required this.pageUrls,
    required this.wallpapers,
  });

  factory DungeonAndFighterWallpaper.fromJson(Map<String, dynamic> json) {
    final int page = json['page']!;
    final List<List<String>> pageUrls = List<List<String>>.from(
        (json['pageUrls'] as List<dynamic>)
            .map((page) => List<String>.from(page)));
    final List<Map<String, String>> wallpapers =
    (json['wallpapers'] as List<dynamic>)
        .map((wallpaper) => Map<String, String>.from(wallpaper))
        .toList();

    return DungeonAndFighterWallpaper(
      page: page,
      pageUrls: pageUrls,
      wallpapers: wallpapers,
    );
  }
}
