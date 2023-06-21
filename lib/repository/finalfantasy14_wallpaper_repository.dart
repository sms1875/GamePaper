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

    // 1페이지 추가
    hrefList.add('/lodestone/special/fankit/smartphone_wallpaper/2_0/#nav_fankit');
    return hrefList;
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
    final response = await http.get(Uri.parse('https://na.finalfantasyxiv.com$urls'));
    if (response.statusCode == 200) {
      final document = parse(response.body);

      final wallpaperInfo=document
          .getElementsByClassName('list_sp_wallpaper clearfix')
          .map((li) => li.querySelectorAll('p'));

      final wallpaperInfoFutures = wallpaperInfo.first.map((p) {
        // 다양한 해상도중에 마지막에 있는 아이폰용 해상도로 가져옴
        final href = p.querySelectorAll('a').last.attributes['href'];
        return fetchWallpaperInfo(href!);
      });

      final wallpapers = await Future.wait(wallpaperInfoFutures.toList());

      return wallpapers;
    } else {
      throw Exception('Failed to load finalfantasy14 wallpaper');
    }
  }

  @override
  Future<Map<String, String>> fetchWallpaperInfo(String url) async {
    return {'url': url, 'src': url,};
  }
}