import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:wallpaper/models/wallpaper.dart';
import 'dart:math';

import 'wallpaper_repository_builder.dart';

class WallpaperRepository {
  static const int _wallpapersPerPage = 12;

  final WallpaperRepositoryBuilder _builder;

  WallpaperRepository(this._builder);

  Future<Wallpaper> fetchWallpapers() async {
    try {
      final response = await http.get(Uri.parse(_builder.baseUrl!));
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
    return _builder.pagingSelector == null ? [_builder.baseUrl!] : _parsePageUrls(response);
  }

  Future<List<String>> _fetchAllWallpaperUrls(List<String> pageUrls) async {
    final List<Future<List<String>>> futures;
    if (_builder.postSelector != null) {
      futures = [_fetchWallpaperUrlsFromPosts(pageUrls)];
    } else {
      futures = pageUrls.map(_fetchWallpaperUrlsFromPage).toList();
    }
    final results = await Future.wait(futures);
    return results.expand((urls) => urls).toList();
  }

  Future<List<String>> _fetchWallpaperUrlsFromPosts(List<String> pageUrls) async {
    final postUrls = await _fetchPostUrls(pageUrls);
    final futures = postUrls.map(_fetchWallpaperUrlsFromPost);
    final results = await Future.wait(futures);
    return results.expand((urls) => urls).toList();
  }

  Future<List<String>> _fetchPostUrls(List<String> pageUrls) async {
    final futures = pageUrls.map(_fetchPostUrlsFromPage);
    final results = await Future.wait(futures);
    return results.expand((urls) => urls).toList();
  }

  Future<List<String>> _fetchPostUrlsFromPage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      return document
          .querySelectorAll(_builder.postSelector!)
          .map((element) => element.attributes[_builder.postAttribute!])
          .where((url) => url != null && url.isNotEmpty)
          .map((url) => (_builder.postUrlPrefix ?? '') + url!)
          .toList();
    } else {
      throw HttpException('Failed to fetch post URLs: ${response.statusCode}');
    }
  }

  Future<List<String>> _fetchWallpaperUrlsFromPost(String url) async {
    final response = await http.get(Uri.parse(url));
    return response.statusCode == 200
        ? _parseWallpaperUrls(response)
        : throw HttpException('Failed to fetch wallpapers from post: ${response.statusCode}');
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
        .querySelectorAll(_builder.pagingSelector!)
        .map((element) => _parseUrl(element, _builder.pagingAttribute!, _builder.pageUrlRegex, _builder.pageUrlGroup))
        .where((url) => url != null && (_builder.pageUrlFilter?.call(url) ?? true))
        .map((url) => _applyUrlPrefix(url, _builder.pageUrlPrefix)!)
        .toSet()
        .toList();
  }

  List<String> _parseWallpaperUrls(http.Response response) {
    final document = parse(response.body);
    return document
        .querySelectorAll(_builder.imageSelector!)
        .map((element) => _parseUrl(element, _builder.imageAttribute!, _builder.imageUrlRegex, _builder.imageUrlGroup))
        .where((url) => url != null && url.isNotEmpty && (_builder.imageUrlFilter?.call(url) ?? true))
        .map((url) => _applyUrlPrefix(url, _builder.imageUrlPrefix)!)
        .toSet()
        .toList();
  }

  String? _parseUrl(Element element, String attributeName, RegExp? regex, int groupNumber) {
    final url = element.attributes[attributeName];
    return url != null && url.isNotEmpty ? _applyUrlPattern(url, regex, groupNumber) : null;
  }

  String? _applyUrlPattern(String url, RegExp? pattern, int groupNumber) {
    if (pattern == null) return url;
    final matches = pattern.firstMatch(url);
    return matches?.group(groupNumber);
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