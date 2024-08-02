class Game {
  final String title;
  final String image;
  final WallpaperData repository;

  Game({
    required this.title,
    required this.image,
    required this.repository,
  });
}

class WallpaperData {
  final String baseUrl;
  final String? pagingElementSelector;
  final String? pagingAttributeName;
  final String imageElementSelector;
  final String imageAttributeName;
  final String? pagingUrlPrefix;
  final String? imageUrlPrefix;
  final RegExp? pageUrlPattern;
  final RegExp? imageUrlPattern;
  final bool Function(String)? pagingUrlFilter;
  final bool Function(String)? imageUrlFilter;
  final int imageUrlGroupNumber;
  final int pageUrlGroupNumber;
  final String? postElementSelector;
  final String? postAttributeName;
  final String? postUrlPrefix;

  WallpaperData({
    required this.baseUrl,
    this.pagingElementSelector,
    this.pagingAttributeName,
    required this.imageElementSelector,
    required this.imageAttributeName,
    this.pagingUrlPrefix,
    this.imageUrlPrefix,
    this.pageUrlPattern,
    this.imageUrlPattern,
    this.pagingUrlFilter,
    this.imageUrlFilter,
    this.imageUrlGroupNumber = 0,
    this.pageUrlGroupNumber = 0,
    this.postElementSelector,
    this.postAttributeName,
    this.postUrlPrefix,
  });
}
