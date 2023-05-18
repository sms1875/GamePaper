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

class PagingWallpaper extends Wallpaper {
  final List<List<String>> pageUrlsList;

  PagingWallpaper({
    required int page,
    required this.pageUrlsList,
    required List<Map<String, String>> wallpapers,
  }) : super(
          page: page,
          pageUrls: pageUrlsList.expand((x) => x).toList(),
          wallpapers: wallpapers,
        );

  factory PagingWallpaper.fromJson(Map<String, dynamic> json) {
    final int page = json['page'];
    final pageUrlsList = json['pageUrls'] as List<List<String>>;
    final wallpapers = json['wallpapers'] as List<Map<String, String>>;

    return PagingWallpaper(
      page: page,
      pageUrlsList: pageUrlsList,
      wallpapers: wallpapers,
    );
  }
}
