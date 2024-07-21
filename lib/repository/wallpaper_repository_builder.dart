import 'package:wallpaper/models/game.dart';
import 'wallpaper_repository.dart';

class WallpaperRepositoryBuilder {
  String? baseUrl;
  String? imageSelector;
  String? imageAttribute;
  RegExp? imageUrlRegex;
  bool Function(String)? imageUrlFilter;
  String? imageUrlPrefix;
  int imageUrlGroup = 0;

  String? pagingSelector;
  String? pagingAttribute;
  RegExp? pageUrlRegex;
  bool Function(String)? pageUrlFilter;
  String? pageUrlPrefix;
  int pageUrlGroup = 0;

  String? postSelector;
  String? postAttribute;
  String? postUrlPrefix;

  WallpaperRepositoryBuilder setBaseUrl(String baseUrl) {
    this.baseUrl = baseUrl;
    return this;
  }

  WallpaperRepositoryBuilder setImageElementInfo(
      String imageSelector,
      String imageAttribute, {
        RegExp? imageUrlRegex,
        bool Function(String)? imageUrlFilter,
        String? imageUrlPrefix,
        int imageUrlGroup = 0,
      }) {
    this.imageSelector = imageSelector;
    this.imageAttribute = imageAttribute;
    this.imageUrlRegex = imageUrlRegex;
    this.imageUrlFilter = imageUrlFilter;
    this.imageUrlPrefix = imageUrlPrefix;
    this.imageUrlGroup = imageUrlGroup;
    return this;
  }

  WallpaperRepositoryBuilder setPagingElementInfo({
    String? pagingSelector,
    String? pagingAttributeName,
    RegExp? pageUrlRegex,
    bool Function(String)? pageUrlFilter,
    String? pageUrlPrefix,
    int pageUrlGroup = 0,
  }) {
    this.pagingSelector = pagingSelector;
    this.pagingAttribute = pagingAttributeName;
    this.pageUrlRegex = pageUrlRegex;
    this.pageUrlFilter = pageUrlFilter;
    this.pageUrlPrefix = pageUrlPrefix;
    this.pageUrlGroup = pageUrlGroup;
    return this;
  }

  WallpaperRepositoryBuilder setPostElementInfo({
    String? postSelector,
    String? postAttribute,
    String? postUrlPrefix,
  }) {
    this.postSelector = postSelector;
    this.postAttribute = postAttribute;
    this.postUrlPrefix = postUrlPrefix;
    return this;
  }

  WallpaperRepositoryBuilder fromData(WallpaperData data) {
    setBaseUrl(data.baseUrl);
    setImageElementInfo(
      data.imageElementSelector,
      data.imageAttributeName,
      imageUrlRegex: data.imageUrlPattern,
      imageUrlFilter: data.imageUrlFilter,
      imageUrlPrefix: data.imageUrlPrefix,
      imageUrlGroup: data.imageUrlGroupNumber,
    );
    setPagingElementInfo(
      pagingSelector: data.pagingElementSelector,
      pagingAttributeName: data.pagingAttributeName,
      pageUrlRegex: data.pageUrlPattern,
      pageUrlFilter: data.pagingUrlFilter,
      pageUrlPrefix: data.pagingUrlPrefix,
      pageUrlGroup: data.pageUrlGroupNumber,
    );
    setPostElementInfo(
      postSelector: data.postElementSelector,
      postAttribute: data.postAttributeName,
      postUrlPrefix: data.postUrlPrefix,
    );
    return this;
  }

  WallpaperRepository build() {
    return WallpaperRepository(this);
  }
}