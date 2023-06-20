import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class MapleStory2WallpaperRepository extends AbstractWallpaperRepository {
  MapleStory2WallpaperRepository()
      : super('https://maplestory2.nexon.com/Main/SearchNews?tk=배경화면%20다운로드');

  @override
  List<String> parsePaging(response) {
    final document = getDocument(response.body);
    final pages = document
        .querySelector('.paginate')!
        .querySelectorAll('span.num a')
        .map((a) => a.attributes['href']!)
        .toList();

    // 1페이지 추가
    pages.insert(0,"/Main/SearchNews?tk=배경화면%20다운로드");
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
  Future<List<Map<String, String>>> fetchPage(int page, List<List<String>> pageUrlsList) async {
    String urls = pageUrlsList[page - 1].first;
    final response = await http.get(Uri.parse('https://maplestory2.nexon.com$urls'));
    if (response.statusCode == 200) {
      final document = parse(response.body);

      // 검색 결과 게시글 목록
      final searchResults = document
          .querySelector('.result_sec')!
          .querySelectorAll('a')
          .map((a) => a.attributes['href']!);

      // 검색 결과의 각 게시글 href 링크로 들어가서 갤럭시 월페이퍼 링크를 가져옴
      final wallpaperInfoFutures = searchResults.map((p) => compute(fetchWallpaperInfoFromSearchResult, p));
      final wallpaperInfoList = await Future.wait(wallpaperInfoFutures.toList());

      // fetchWallpaperInfoFromSearchResult를 통해 받아온 wallpaperInfoList 정보를 wallpapers에 더하기
      List<Map<String, String>> wallpapers = [];
      for (var wallpaperList in wallpaperInfoList) {
        wallpapers.addAll(wallpaperList);
      }

      // 빈 값이나 예외처리된 월페이퍼 제거
      wallpapers.removeWhere((element) => element['url'] == '' || element.isEmpty);

      return wallpapers;
    } else {
      throw Exception('Failed to load maplestory2 wallpaper search result');
    }
  }

  // 멀티쓰레딩을 위한 함수 분리
  Future<List<Map<String, String>>> fetchWallpaperInfoFromSearchResult(String p) async {
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

      // redirect 된 경우 다시 fetchWallpaperInfoFromSearchResult 함수를 호출
      if (document.querySelector('.board_view_body') == null) {
        return await fetchWallpaperInfoFromSearchResult(p);
      }

      final galaxyHref = document
          .querySelector('.board_view_body')!
          .querySelectorAll('a')
          .map((a) => a.attributes['href']!)
          .where((href) => href.contains('galaxy'))
          .toList();

      // 갤럭시 월페이퍼가 없는 경우 예외처리
      if (galaxyHref.isEmpty) galaxyHref.add('');

      final wallpaperInfoFutures = galaxyHref.map((href) => fetchWallpaperInfo(href));
      final wallpaperInfoList = await Future.wait(wallpaperInfoFutures.toList());
      return wallpaperInfoList;
    } else {
      throw Exception('Failed to load maplestory2 wallpaper');
    }
  }

  @override
  Future<Map<String, String>> fetchWallpaperInfo(String url) async {
    return {'url': url, 'src': url,};
  }
}
