import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class WorldOfTanksWallpaperRepository extends AbstractWallpaperRepository {
  WorldOfTanksWallpaperRepository(String baseUrl) : super(
    baseUrl: baseUrl,
    selector: '.content-wrapper .b-pager_item__pages a:last-child',
    attributeName: 'href',
  );

  @override
  List<String> parsePaging(http.Response response) {
    final document = getDocument(response.body);
    final lastPageHref = document.find(selector)?.attributes['href'];

    if (lastPageHref == null) {
      return [];
    }

    final maxPageNum = int.parse(lastPageHref.split('page=')[1]) - 4;
    return List<String>.generate(
        maxPageNum, (index) => '/ko/media/tag/11/?page=${index + 1}');
  }

  @override
  List<List<String>> generatePageUrlsList(List<String> paging) {
    int pageSize = 1;
    return List.generate(
      (paging.length / pageSize).ceil(),
          (i) => paging.skip(i * pageSize).take(pageSize).toList(),
    );
  }

  @override
  Future<List<String>> fetchPage(int page, List<List<String>> pageUrlsList) async {
    String urls = pageUrlsList[page - 1].first;

    final response = await http.get(Uri.parse('http://worldoftanks.asia$urls'));
    if (response.statusCode == 200) {
      final document = parse(response.body);

      final searchResults = document
          .querySelector('.content-wrapper')!
          .getElementsByClassName('b-img-signature_link')
          .map((a) => a.attributes['href']!);

      final wallpaperInfoFutures = searchResults.map((p) => compute(fetchWallpaperInfoFromSearchResult, p));
      final wallpaperInfoList = await Future.wait(wallpaperInfoFutures.toList());

      List<String> wallpapers = wallpaperInfoList.expand((list) => list).toList();

      wallpapers.removeWhere((element) => element.isEmpty);

      return wallpapers;
    } else {
      throw Exception('Failed to load HTML');
    }
  }

  // 멀티쓰레딩을 위한 함수 분리
  Future<List<String>> fetchWallpaperInfoFromSearchResult(String p) async {
    final response = await http.get(Uri.parse('https://worldoftanks.asia$p'));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      final galaxyHref = document
          .querySelector('.b-content__media-description')!
          .querySelectorAll('a')
          .where((a) => a.attributes['href'] != null)
          .map((a) => a.attributes['href']!)
          .where((href) => href.contains('1200x2300') || href.contains('mobile') || href.contains('mw_'))
          .toSet();

      if (galaxyHref.isEmpty) return [''];

      final wallpaperInfoFutures = galaxyHref.map((href) => fetchWallpaperInfo(href));
      return await Future.wait(wallpaperInfoFutures.toList());
    } else {
      throw Exception('Failed to load HTML');
    }
  }
}