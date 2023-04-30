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
    final int page = json['page'];
    final pageUrls = json['pageUrls'] as List<String>;
    final wallpapers = json['wallpapers'] as List<Map<String, String>>;
    return Wallpaper(
      page: page,
      pageUrls: pageUrls,
      wallpapers: wallpapers,
    );
  }
}

class DungeonAndFighterWallpaper extends Wallpaper {
  final List<List<String>> pageUrlsList;

  DungeonAndFighterWallpaper({
    required int page,
    required this.pageUrlsList,
    required List<Map<String, String>> wallpapers,
  }) : super(
          page: page,
          pageUrls: pageUrlsList.expand((x) => x).toList(),
          wallpapers: wallpapers,
        );

  factory DungeonAndFighterWallpaper.fromJson(Map<String, dynamic> json) {
    final int page = json['page'];
    final pageUrlsList = json['pageUrls'] as List<List<String>>;
    final wallpapers = json['wallpapers'] as List<Map<String, String>>;

    return DungeonAndFighterWallpaper(
      page: page,
      pageUrlsList: pageUrlsList,
      wallpapers: wallpapers,
    );
  }
}
