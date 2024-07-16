import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/models/wallpaper.dart';
import 'dart:core';

abstract class BaseWallpaperRepository {
  final String baseUrl;
  final String imageElementSelector;
  final String imageAttributeName;
  final String? pagingElementSelector;
  final String? pagingAttributeName;
  final RegExp? pageUrlPattern;
  final String? pageUrlReplacement;
  final RegExp? imageUrlPattern;
  final String? imageUrlReplacement;
  final bool Function(String)? pagingUrlFilter;
  final bool Function(String)? imageUrlFilter;
  final String? pagingUrlPrefix;
  final String? imageUrlPrefix;
  final int imageUrlGroupNumber;
  final int pageUrlGroupNumber;

  BaseWallpaperRepository({
    required this.baseUrl,
    required this.imageElementSelector,
    required this.imageAttributeName,
    this.pagingElementSelector,
    this.pagingAttributeName,
    this.pageUrlPattern,
    this.pageUrlReplacement,
    this.imageUrlPattern,
    this.imageUrlReplacement,
    this.pagingUrlFilter,
    this.imageUrlFilter,
    this.pagingUrlPrefix,
    this.imageUrlPrefix,
    this.imageUrlGroupNumber = 0,
    this.pageUrlGroupNumber = 0,
  });

  Future<Wallpaper> fetchWallpaper() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final pageUrls = pagingElementSelector != null ? _extractPageUrls(response) : [baseUrl];
      final allWallpaperUrls = await _fetchAllWallpaperUrls(pageUrls);
      final pagedWallpaperUrls = _paginateWallpaperUrls(allWallpaperUrls);
      return Wallpaper(
        page: List.generate(pagedWallpaperUrls.length, (index) => index + 1),
        pageUrlsList: pageUrls,
        wallpapers: pagedWallpaperUrls,
      );
    } else {
      throw Exception('Failed to fetch wallpaper');
    }
  }

  Future<List<String>> _fetchAllWallpaperUrls(List<String> pageUrls) async {
    List<String> allWallpaperUrls = [];
    for (String url in pageUrls) {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        allWallpaperUrls.addAll(_extractWallpaperUrls(response));
      } else {
        throw Exception('Failed to load wallpaper from $url');
      }
    }
    return allWallpaperUrls;
  }

  List<List<String>> _paginateWallpaperUrls(List<String> allWallpaperUrls) {
    List<List<String>> pagedWallpaperUrls = [];
    for (int i = 0; i < allWallpaperUrls.length; i += 21) {
      pagedWallpaperUrls.add(
          allWallpaperUrls.sublist(i, i + 21 > allWallpaperUrls.length ? allWallpaperUrls.length : i + 21)
      );
    }
    return pagedWallpaperUrls;
  }

  List<String> _extractPageUrls(http.Response response) {
    final document = BeautifulSoup(response.body);
    return document
        .findAll(pagingElementSelector!)
        .map((element) => _extractUrl(element, pagingAttributeName!, pageUrlPattern, pageUrlReplacement, pageUrlGroupNumber))
        .where((url) => url != null && (pagingUrlFilter?.call(url) ?? true))
        .map((url) => pagingUrlPrefix != null ? '$pagingUrlPrefix$url' : url!)
        .toSet()
        .toList();
  }

  List<String> _extractWallpaperUrls(http.Response response) {
    final document = BeautifulSoup(response.body);
    return document
        .findAll(imageElementSelector)
        .map((element) => _extractUrl(element, imageAttributeName, imageUrlPattern, imageUrlReplacement, imageUrlGroupNumber))
        .where((url) => url != null && (imageUrlFilter?.call(url) ?? true))
        .map((url) => imageUrlPrefix != null ? '$imageUrlPrefix$url' : url!)
        .toSet()
        .toList();
  }

  String? _extractUrl(element, String attributeName, RegExp? pattern, String? replacement, int groupNumber) {
    String? url = element.attributes[attributeName];
    if (url != null && pattern != null && replacement != null) {
      url = url.replaceFirstMapped(pattern, (match) => match.group(groupNumber)!);
    }
    return url;
  }
}