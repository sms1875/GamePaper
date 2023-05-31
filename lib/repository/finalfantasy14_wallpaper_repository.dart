import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class FinalFantasy14WallpaperRepository extends AbstractWallpaperRepository {
  FinalFantasy14WallpaperRepository()
      : super('https://na.finalfantasyxiv.com/lodestone/special/fankit/smartphone_wallpaper/2_0/#nav_fankit');

  @override
  List<String> parsePaging(response) {
    final document = getDocument(response.body);
    final hrefList=document
        .getElementById('pc_wallpaper')!
        .querySelectorAll('a')
        .map((a) => a.attributes['href']!)
        .where((href) => href.contains('smartphone_wallpaper'))
        .toList();
    hrefList.add('/lodestone/special/fankit/smartphone_wallpaper/2_0/#nav_fankit');

    return hrefList;
  }

  @override
  List<List<String>> generatePageUrlsList(List<String> paging) {
    int pageSize = 1; //[[$page=1], [$page=2], ...]
    List<List<String>> pageUrlsList = List.generate(
      (paging.length / pageSize).ceil(),
          (i) => paging.skip(i * pageSize).take(pageSize).toList(),
    );
    pageUrlsList.removeLast(); // 마지막 페이지는 모바일 월페이퍼가 없어서 페이지목록에서 제거
    return pageUrlsList;
  }

  @override
  Future<List<Map<String, String>>> fetchPage(int page, List<List<String>> pageUrlsList) async {
    String urls = pageUrlsList[page - 1].first;
    final response = await http.get(Uri.parse('https://na.finalfantasyxiv.com$urls'));
    if (response.statusCode == 200) {
      final document = parse(response.body);

      final wallpaperInfo=document
          .getElementsByClassName('list_sp_wallpaper clearfix')
          .map((li) => li.querySelectorAll('p'));

      final wallpaperInfoFutures = wallpaperInfo.first.map((p) {
        final href = p.querySelectorAll('a').last.attributes['href'];
        return fetchWallpaperInfo(href!);
      });

      final wallpapers = await Future.wait(wallpaperInfoFutures.toList());

      return wallpapers;
    } else {
      throw Exception('Failed to load HTML');
    }
  }

  @override
  Future<Map<String, String>> fetchWallpaperInfo(String url) async {
    return {'url': url, 'src': url,};
  }
}