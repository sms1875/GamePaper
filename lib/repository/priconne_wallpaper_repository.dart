import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class PriConneWallpaperRepository extends AbstractWallpaperRepository {
  PriConneWallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    selector: '.pager > ul > li > a',
    attributeName: 'href',
    customFilterCondition: (href) => href != 'javascript:void(0)',
  );


  @override
  List<String> parsePaging(http.Response response) {
    List<String> pages = super.parsePaging(response);
    // 1페이지 추가
    pages.insert(0, "https://priconne-redive.jp/fankit02/");
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
    final response = await http.get(Uri.parse(urls));
    if (response.statusCode == 200) {
      final document = parse(response.body);

      final fankitList = document
          .getElementById('contents')!
          .querySelectorAll('.fankit-list > li > a')
          .map((a) => a.attributes['href']!);

      final wallpaperInfoFutures = fankitList.map((p) => compute(fetchWallpaperInfoFromFankitList, p));
      final wallpaperInfoList = await Future.wait(wallpaperInfoFutures.toList());

      List<String> wallpapers = wallpaperInfoList.expand((list) => list).toList();

      wallpapers.removeWhere((element) => element.isEmpty);

      return wallpapers;
    } else {
      throw Exception('Failed to load priconne wallpaper');
    }
  }

  // 멀티쓰레딩을 위한 함수 분리
  Future<List<String>> fetchWallpaperInfoFromFankitList(String p) async {
    final response = await http.get(Uri.parse(p));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      final iphoneHref = document
          .querySelector('.wallpaper-list')!
          .querySelectorAll('.dl-btns > li > a')
          .where((a) => a.querySelector('.purpose')!.text.contains('iPhone'))
          .map((a) => a.attributes['href']!)
          .toSet();

      if (iphoneHref.isEmpty) return [''];

      final wallpaperInfoFutures = iphoneHref.map((href) => fetchWallpaperInfo(href));
      return await Future.wait(wallpaperInfoFutures.toList());
    } else {
      throw Exception('Failed to load HTML');
    }
  }
}
