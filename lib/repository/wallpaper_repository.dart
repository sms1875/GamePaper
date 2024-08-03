import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:wallpaper/models/wallpaper.dart';
import 'dart:math';

class WallpaperRepository {
  static const int _wallpapersPerPage = 12;

  final String baseUrl = 'https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/';
  final String imageSelector = '#wallpaper_list > li > a[attr-img_m]';
  final String imageAttribute = 'attr-img_m';
  final String? pagingSelector = 'div.paging > a';
  final String? pagingAttribute = 'href';
  final String? pageUrlPrefix = 'https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/';

  WallpaperRepository();

  Future<Wallpaper> fetchWallpapers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final pageUrls = await _getPageUrls(response);
        final allWallpaperUrls = await _fetchAllWallpaperUrls(pageUrls);
        final pagedWallpaperUrls = _paginateWallpapers(allWallpaperUrls);
        return Wallpaper(
          pageNumbers: List.generate(pagedWallpaperUrls.length, (index) => index + 1),
          pageUrls: pageUrls,
          wallpapersByPage: pagedWallpaperUrls,
        );
      } else {
        throw HttpException('Failed to fetch wallpaper: ${response.statusCode}');
      }
    } catch (e) {
      throw WallpaperFetchException('Error fetching wallpaper: $e');
    }
  }

  Future<List<String>> _getPageUrls(http.Response response) async {
    return pagingSelector == null ? [baseUrl] : _parsePageUrls(response);
  }

  Future<List<String>> _fetchAllWallpaperUrls(List<String> pageUrls) async {
    final futures = pageUrls.map(_fetchWallpaperUrlsFromPage).toList();
    final results = await Future.wait(futures);
    return results.expand((urls) => urls).toList();
  }

  Future<List<String>> _fetchWallpaperUrlsFromPage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200
          ? _parseWallpaperUrls(response)
          : throw HttpException('Failed to load wallpaper from $url: ${response.statusCode}');
    } catch (e) {
      throw WallpaperFetchException('Error fetching wallpaper from $url: $e');
    }
  }

  List<List<String>> _paginateWallpapers(List<String> allWallpaperUrls) {
    return [
      for (var i = 0; i < allWallpaperUrls.length; i += _wallpapersPerPage)
        allWallpaperUrls.sublist(i, min(i + _wallpapersPerPage, allWallpaperUrls.length))
    ];
  }

  List<String> _parsePageUrls(http.Response response) {
    final document = parse(response.body);
    return document
        .querySelectorAll(pagingSelector!)
        .map((element) => element.attributes[pagingAttribute!]!)
        .map((url) => _applyUrlPrefix(url, pageUrlPrefix)!)
        .toSet()
        .toList();
  }

  List<String> _parseWallpaperUrls(http.Response response) {
    final document = parse(response.body);
    return document
        .querySelectorAll(imageSelector)
        .map((element) => element.attributes[imageAttribute]!)
        .toSet()
        .toList();
  }

  String? _applyUrlPrefix(String? url, String? prefix) {
    return url != null ? (prefix ?? '') + url : null;
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
