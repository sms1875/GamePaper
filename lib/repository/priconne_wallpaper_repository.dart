import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class PriConneWallpaperRepository extends AbstractWallpaperRepository {
  PriConneWallpaperRepository()
      : super('https://priconne-redive.jp/fankit02/');

  @override
  List<String> parsePaging(response) {
    final document = getDocument(response.body);
    final pages = document
        .querySelectorAll('.pager > ul > li > a')
        .map((a) => a.attributes['href']!)
        .toList();

    // pages의 javascript:void(0) 제거 후  1페이지 추가
    pages.removeAt(0);
    pages.insert(0,"https://priconne-redive.jp/fankit02/");
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
    final response = await http.get(Uri.parse(urls));
    if (response.statusCode == 200) {
      final document = parse(response.body);

      // 팬키트 목록
      final fankitList = document
          .getElementById('contents')!
          .querySelectorAll('.fankit-list > li > a')
          .map((a) => a.attributes['href']!);

      final wallpaperInfoFutures = fankitList.map((p) => compute(fetchWallpaperInfoFromFankitList, p));
      final wallpaperInfoList = await Future.wait(wallpaperInfoFutures.toList());

      // fetchWallpaperInfoFromFankitList를 통해 받아온 wallpaperInfoList 정보를 wallpapers에 더하기
      List<Map<String, String>> wallpapers = [];
      for (var wallpaperList in wallpaperInfoList) {
        wallpapers.addAll(wallpaperList);
      }

      // 빈 값이나 예외처리된 월페이퍼 제거
      wallpapers.removeWhere((element) => element['url'] == '' || element.isEmpty);

      return wallpapers;
    } else {
      throw Exception('Failed to load priconne wallpaper');
    }
  }

  // 멀티쓰레딩을 위한 함수 분리
  Future<List<Map<String, String>>> fetchWallpaperInfoFromFankitList(String p) async {
    final response = await http.get(Uri.parse(p));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      // iphone용 (1080 x 1920) 월페이퍼
      final iphoneHref = document
          .querySelector('.wallpaper-list')!
          .querySelectorAll('.dl-btns > li > a')
          .where((a) => a.querySelector('.purpose')!.text.contains('iPhone'))
          .map((a) => a.attributes['href']!)
          .toSet();

      // 월페이퍼가 없는 경우 예외처리
      if (iphoneHref.isEmpty) iphoneHref.add('');

      final wallpaperInfoFutures = iphoneHref.map((href) => fetchWallpaperInfo(href));
      final wallpaperInfoList = await Future.wait(wallpaperInfoFutures.toList());
      return wallpaperInfoList;
    } else {
      throw Exception('Failed to load HTML');
    }
  }

  @override
  Future<Map<String, String>> fetchWallpaperInfo(String url) async {
    return {'url': url, 'src': url,};
  }
}
