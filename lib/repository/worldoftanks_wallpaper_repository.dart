import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class WorldOfTanksWallpaperRepository extends AbstractWallpaperRepository {
  WorldOfTanksWallpaperRepository()
      : super('https://worldoftanks.asia/ko/media/tag/11/');

  @override
  List<String> parsePaging(response) {
    final document = getDocument(response.body);

    final pagenum = document
        .querySelector('.content-wrapper .b-pager_item__pages a:last-child')!
        .attributes['href']!;

    final maxPageNum = int.parse(pagenum.split('page=')[1]) - 4;
    return List<String>.generate(
        maxPageNum, (index) => '/ko/media/tag/11/?page=${index + 1}');
  }

  @override
  List<List<String>> generatePageUrlsList(List<String> paging) {
    int pageSize = 1;
    // [[$page=1], [$page=2], ...]
    List<List<String>> pageUrlsList = List.generate(
      (paging.length / pageSize).ceil(),
          (i) => paging.skip(i * pageSize).take(pageSize).toList(),
    );
    return pageUrlsList;
  }

  @override
  Future<List<Map<String, String>>> fetchPage(int page, List<List<String>> pageUrlsList) async {
    String urls = pageUrlsList[page - 1].first;

    final response =
    await http.get(Uri.parse('http://worldoftanks.asia$urls'));
    if (response.statusCode == 200) {
      final document = parse(response.body);

      // 월페이퍼 검색 결과
      final searchResults = document
          .querySelector('.content-wrapper')!
          .getElementsByClassName('b-img-signature_link')
          .map((a) => a.attributes['href']!);

      // 검색 결과의 각 게시글 href 링크로 들어가서 갤럭시 월페이퍼 링크를 가져옴
      final wallpaperInfoFutures = searchResults.map((p) => compute(fetchWallpaperInfoFromSearchResult, p));
      final wallpapers = await Future.wait(wallpaperInfoFutures.toList());

      // 예외처리된 월페이퍼 제거
      wallpapers.removeWhere((element) => element['url'] == '');
      return wallpapers;
    } else {
      throw Exception('Failed to load HTML');
    }
  }

  // 멀티쓰레딩을 위한 함수 분리
  Future<Map<String, String>> fetchWallpaperInfoFromSearchResult(String p) async {
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

      // 갤럭시 월페이퍼가 없는 경우 예외처리
      if (galaxyHref.isEmpty) galaxyHref.add('');
      final wallpaperInfoList = await Future.wait(galaxyHref.map((href) => fetchWallpaperInfo(href)).toList());

      // 결과 합치기
      return wallpaperInfoList.reduce((mergedInfo, currentInfo) => mergedInfo..addAll(currentInfo));
    } else {
      throw Exception('Failed to load HTML');
    }
  }

  @override
  Future<Map<String, String>> fetchWallpaperInfo(String url) async {
    return {'url': url, 'src': url};
  }
}
