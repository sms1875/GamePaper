import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class MapleStory2WallpaperRepository extends AbstractWallpaperRepository {
  MapleStory2WallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    selector: '.paginate > span.num a',
    attributeName: 'href',
  );

  @override
  List<String> parsePaging(http.Response response) {
    List<String> pages = super.parsePaging(response);
    // 1페이지 추가
    pages.insert(0, "/Main/SearchNews?tk=배경화면%20다운로드");
    return pages;
  }

  @override
  List<List<String>> generatePageUrlsList(List<String> paging) {
    // [[$page=1], [$page=2], ...]
    int pageSize = 1;
    List<List<String>> pageUrlsList = List.generate(
      (paging.length / pageSize).ceil(),
          (i) => paging.skip(i * pageSize).take(pageSize).toList(),
    );
    return pageUrlsList;
  }

  @override
  Future<List<String>> fetchPage(int page, List<List<String>> pageUrlsList) async {
    String urls = pageUrlsList[page - 1].first;
    final response = await http.get(Uri.parse('https://maplestory2.nexon.com$urls'));
    if (response.statusCode == 200) {
      final document = parse(response.body);

      final searchResults = document
          .querySelector('.result_sec')!
          .querySelectorAll('a')
          .map((a) => a.attributes['href']!);

      final wallpaperInfoFutures = searchResults.map((p) => compute(fetchWallpaperInfoFromSearchResult, p));
      final wallpaperInfoList = await Future.wait(wallpaperInfoFutures.toList());

      List<String> wallpapers = wallpaperInfoList.expand((list) => list).toList();

      wallpapers.removeWhere((element) => element.isEmpty);

      return wallpapers;
    } else {
      throw Exception('Failed to load maplestory2 wallpaper search result');
    }
  }

  // 멀티쓰레딩을 위한 함수 분리
  Future<List<String>> fetchWallpaperInfoFromSearchResult(String p) async {
    final client = http.Client();
    var uri = Uri.parse('https://maplestory2.nexon.com$p');
    var request = http.Request('GET', uri);
    request.followRedirects = false;
    var response = await client.send(request);
    while (response.isRedirect) {
      response.stream.drain();
      final location = response.headers['location'];
      if (location != null) {
        uri = Uri.parse(location);
        request = http.Request('GET', uri);
        request.followRedirects = false;
        response = await client.send(request);
      }
    }

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final document = parse(responseBody);

      if (document.querySelector('.board_view_body') == null) {
        return await fetchWallpaperInfoFromSearchResult(p);
      }

      final galaxyHref = document
          .querySelector('.board_view_body')!
          .querySelectorAll('a')
          .map((a) => a.attributes['href']!)
          .where((href) => href.contains('galaxy'))
          .toList();

      if (galaxyHref.isEmpty) return [''];

      final wallpaperInfoFutures = galaxyHref.map((href) => fetchWallpaperInfo(href));
      return await Future.wait(wallpaperInfoFutures.toList());
    } else {
      throw Exception('Failed to load maplestory2 wallpaper');
    }
  }
}
