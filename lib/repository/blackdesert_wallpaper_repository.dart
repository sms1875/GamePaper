import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class BlackDesertWallpaperRepository extends AbstractWallpaperRepository {
  BlackDesertWallpaperRepository()
      : super('https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/');

  @override
  List<String> parsePaging(response) {
    final document = getDocument(response.body);
    return document
        .getElementById('paging')!
        .querySelectorAll('a')
        .map((a) => a.attributes['href']!)
        .toSet()
        .toList();
  }

  @override
  List<List<String>> generatePageUrlsList(List<String> paging) {
    // [[$page=1], [$page=2], ...]
    int pageSize = 1;
    List<List<String>> pageUrlsList = List.generate(
      (paging.length / pageSize).ceil(),
          (i) => paging.skip(i * pageSize).take(pageSize).toList(),
    );
    // 마지막 페이지는 모바일 월페이퍼가 없어서 페이지목록에서 제거
    pageUrlsList.removeLast();
    return pageUrlsList;
  }

  @override
  Future<List<Map<String, String>>> fetchPage(int page, List<List<String>> pageUrlsList) async {
    String urls = pageUrlsList[page - 1].first;
    final response = await http.get(Uri.parse('$baseUrl$urls'));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      var wallpaperList = document.querySelector('#wallpaper_list');
      final wallpaperInfoFutures = wallpaperList!
          .querySelectorAll('li')
          .where((li) => li.querySelector('a')!.attributes.containsKey('attr-img_m'))
          .map((li) {
        final a = li.querySelector('a')!;
        final attrImgM = a.attributes['attr-img_m']!;
        return fetchWallpaperInfo(attrImgM);
      });
      final wallpapers = await Future.wait(wallpaperInfoFutures.toList());

      return wallpapers;
    } else {
      throw Exception('Failed to load blackdesert wallpaper');
    }
  }

  @override
  Future<Map<String, String>> fetchWallpaperInfo(String url) async {
    return {'url': url, 'src': url,};
  }
}
