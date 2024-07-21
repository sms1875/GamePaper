import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:wallpaper/models/wallpaper.dart';
import 'dart:math';

class BaseWallpaperRepository {
  static const int WALLPAPERS_PER_PAGE = 21;

  final String baseUrl;
  final String imageElementSelector;
  final String imageAttributeName;
  final String? pagingElementSelector;
  final String? pagingAttributeName;
  final RegExp? pageUrlPattern;
  final RegExp? imageUrlPattern;
  final bool Function(String)? pagingUrlFilter;
  final bool Function(String)? imageUrlFilter;
  final String? pagingUrlPrefix;
  final String? imageUrlPrefix;
  final int imageUrlGroupNumber;
  final int pageUrlGroupNumber;

  // New fields for post handling
  final String? postElementSelector;
  final String? postAttributeName;
  final String? postUrlPrefix;
  final bool usePostStructure;

  BaseWallpaperRepository({
    required this.baseUrl,
    required this.imageElementSelector,
    required this.imageAttributeName,
    this.pagingElementSelector,
    this.pagingAttributeName,
    this.pageUrlPattern,
    this.imageUrlPattern,
    this.pagingUrlFilter,
    this.imageUrlFilter,
    this.pagingUrlPrefix,
    this.imageUrlPrefix,
    this.imageUrlGroupNumber = 0,
    this.pageUrlGroupNumber = 0,
    this.postElementSelector,
    this.postAttributeName,
    this.postUrlPrefix,
    this.usePostStructure = false,
  });

  Future<Wallpaper> fetchWallpaper() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final pageUrls = await _getPageUrls(response);
        final allWallpaperUrls = await _fetchAllWallpaperUrls(pageUrls);
        final pagedWallpaperUrls = _paginateWallpaperUrls(allWallpaperUrls);
        return Wallpaper(
          page: List.generate(pagedWallpaperUrls.length, (index) => index + 1),
          pageUrlsList: pageUrls,
          wallpapers: pagedWallpaperUrls,
        );
      } else {
        throw HttpException('Failed to fetch wallpaper: ${response.statusCode}');
      }
    } catch (e) {
      throw WallpaperFetchException('Error fetching wallpaper: $e');
    }
  }

  Future<List<String>> _getPageUrls(http.Response response) async {
    if (pagingElementSelector == null) return [baseUrl];
    return _extractPageUrls(response);
  }

  Future<List<String>> _fetchAllWallpaperUrls(List<String> pageUrls) async {
    if (usePostStructure) {
      return _fetchWallpaperUrlsFromPosts(pageUrls);
    } else {
      final futures = pageUrls.map((url) => _fetchWallpaperUrlsFromPage(url));
      final results = await Future.wait(futures);
      return results.expand((urls) => urls).toList();
    }
  }

  Future<List<String>> _fetchWallpaperUrlsFromPosts(List<String> pageUrls) async {
    final postUrls = await _getAllPostUrls(pageUrls);
    final futures = postUrls.map((url) => _fetchWallpaperUrlsFromPost(url));
    final results = await Future.wait(futures);
    return results.expand((urls) => urls).toList();
  }

  Future<List<String>> _getAllPostUrls(List<String> pageUrls) async {
    final futures = pageUrls.map((url) => _getPostUrlsFromPage(url));
    final results = await Future.wait(futures);
    return results.expand((urls) => urls).toList();
  }

  Future<List<String>> _getPostUrlsFromPage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      return document
          .querySelectorAll(postElementSelector!)
          .map((element) => element.attributes[postAttributeName!])
          .where((url) => url != null && url.isNotEmpty)
          .map((url) => (postUrlPrefix ?? '') + url!)
          .toList();
    } else {
      throw HttpException('Failed to fetch post URLs: ${response.statusCode}');
    }
  }

  Future<List<String>> _fetchWallpaperUrlsFromPost(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return _extractWallpaperUrls(response);
    } else {
      throw HttpException('Failed to fetch wallpapers from post: ${response.statusCode}');
    }
  }

  Future<List<String>> _fetchWallpaperUrlsFromPage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return _extractWallpaperUrls(response);
      } else {
        throw HttpException('Failed to load wallpaper from $url: ${response.statusCode}');
      }
    } catch (e) {
      throw WallpaperFetchException('Error fetching wallpaper from $url: $e');
    }
  }

  List<List<String>> _paginateWallpaperUrls(List<String> allWallpaperUrls) {
    return [
      for (var i = 0; i < allWallpaperUrls.length; i += WALLPAPERS_PER_PAGE)
        allWallpaperUrls.sublist(i, min(i + WALLPAPERS_PER_PAGE, allWallpaperUrls.length))
    ];
  }

  List<String> _extractPageUrls(http.Response response) {
    final document = parse(response.body);
    return document
        .querySelectorAll(pagingElementSelector!)
        .map((element) => _extractUrl(element, pagingAttributeName!, pageUrlPattern, pageUrlGroupNumber))
        .where((url) => url != null && (pagingUrlFilter?.call(url) ?? true))
        .map((url) => _processUrl(url, pagingUrlPrefix, null, 0)!)
        .toSet()
        .toList();
  }

  List<String> _extractWallpaperUrls(http.Response response) {
    final document = parse(response.body);
    return document
        .querySelectorAll(imageElementSelector)
        .map((element) => _extractUrl(element, imageAttributeName, imageUrlPattern, imageUrlGroupNumber))
        .where((url) => url != null && url.isNotEmpty && (imageUrlFilter?.call(url) ?? true))
        .map((url) => _processUrl(url, imageUrlPrefix, null, 0)!)
        .toSet()
        .toList();
  }

  String? _extractUrl(Element element, String attributeName, RegExp? pattern, int groupNumber) {
    String? url = element.attributes[attributeName];
    if (url != null && url.isEmpty) {
      url = null;
    }
    return _processUrl(url, null, pattern, groupNumber);
  }

  String? _processUrl(String? url, String? prefix, RegExp? pattern, int groupNumber) {
    if (url == null) return null;
    if (pattern != null) {
      final matches = pattern.firstMatch(url);
      url = matches?.group(groupNumber);
    }
    return url != null ? (prefix ?? '') + url : null;
  }

  static BaseWallpaperRepository create({
    required String baseUrl,
    String? pagingElementSelector,
    String? pagingAttributeName,
    required String imageElementSelector,
    required String imageAttributeName,
    String? pagingUrlPrefix,
    String? imageUrlPrefix,
    RegExp? pageUrlPattern,
    RegExp? imageUrlPattern,
    bool Function(String)? pagingUrlFilter,
    bool Function(String)? imageUrlFilter,
    int imageUrlGroupNumber = 0,
    int pageUrlGroupNumber = 0,
    bool usePostStructure = false,
    String? postElementSelector,
    String? postAttributeName,
    String? postUrlPrefix,
  }) {
    return BaseWallpaperRepository(
      baseUrl: baseUrl,
      pagingElementSelector: pagingElementSelector,
      pagingAttributeName: pagingAttributeName,
      imageElementSelector: imageElementSelector,
      imageAttributeName: imageAttributeName,
      pagingUrlPrefix: pagingUrlPrefix,
      imageUrlPrefix: imageUrlPrefix,
      pageUrlPattern: pageUrlPattern,
      imageUrlPattern: imageUrlPattern,
      pagingUrlFilter: pagingUrlFilter,
      imageUrlFilter: imageUrlFilter,
      imageUrlGroupNumber: imageUrlGroupNumber,
      pageUrlGroupNumber: pageUrlGroupNumber,
      usePostStructure: usePostStructure,
      postElementSelector: postElementSelector,
      postAttributeName: postAttributeName,
      postUrlPrefix: postUrlPrefix,
    );
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
  @override
  String toString() => 'HttpException: $message';
}

class WallpaperFetchException implements Exception {
  final String message;
  WallpaperFetchException(this.message);
  @override
  String toString() => 'WallpaperFetchException: $message';
}