import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class MapleStory2WallpaperRepository extends AbstractWallpaperRepository {
  MapleStory2WallpaperRepository()
      : super('https://maplestory2.nexon.com/Main/SearchNewsCategory?page=1&tk=%5B갤럭시%5D&t=media');

  @override
  List<String> parsePaging(response) {
    final document = getDocument(response.body);
    final pages = document
        .querySelector('.paginate')!
        .querySelectorAll('span.num a')
        .map((a) => a.attributes['href']!)
        .toList();

    //1페이지 추가
    pages.insert(0,"/Main/SearchNewsCategory?page=1&tk=%5B갤럭시%5D&t=media");
    return pages;
  }

  @override
  List<List<String>> generatePageUrlsList(List<String> paging) {
    //[[$page=1], [$page=2], ...]
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

      //검색 결과 게시글 목록
      final searchResults=document
          .querySelector('.result_sec')!
          .querySelectorAll('a')
          .map((a) => a.attributes['href']!);

      //검색 결과의 각 게시글 href 링크로 들어가서 갤럭시 월페이퍼 링크를 가져옴
      final wallpaperInfoFutures = searchResults.map((p) async {
        final response2 = await http.get(Uri.parse('https://maplestory2.nexon.com$p'));
        if (response2.statusCode == 200) {
          final document2 = parse(response2.body);

          final galaxyHref = document2
              .querySelector('.board_view_body')!
              .querySelectorAll('a')
              .map((a) => a.attributes['href']!)
              .where((href) => href.contains('galaxy'));

          final hrefMap = await Future.wait(galaxyHref.map((href) => fetchWallpaperInfo(href)));
          return hrefMap.reduce((mergedMap, currentMap) => mergedMap..addAll(currentMap));
        } else {
          throw Exception('Failed to load maplestory2 wallpaper');
        }
      });
      final wallpapers = await Future.wait(wallpaperInfoFutures.toList());
      return wallpapers;
    } else {
      throw Exception('Failed to load maplestory2 wallpaper search result');
    }
  }

  @override
  Future<Map<String, String>> fetchWallpaperInfo(String url) async {
    return {'url': url, 'src': url,};
  }
}
