import 'package:html/parser.dart';
import 'package:wallpaper/data/wallpaper.dart';
import 'package:http/http.dart' as http;

class BlackDesertWallpaperRepository {
  String baseUrl = 'https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/';
  Wallpaper? cachedWallpaper;

  Future<Wallpaper> fetchBlackDesertWallpaper() async {
    if (cachedWallpaper != null) {
      return cachedWallpaper!;
    }

    int page = 1;
    String getUrl = '?boardType=0&searchType=&searchText=&Page=$page';
    final response = await http.get(Uri.parse('$baseUrl$getUrl'));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      final paging = document.getElementById('paging');
      final pageUrls = paging!
          .querySelectorAll('a')
          .map((a) => a.attributes['href']!)
          .toSet()
          .toList();
      pageUrls.removeLast();// 마지막 페이지는 모바일 월페이퍼가 없어서 페이지목록에서 제거
      final wallpapers = await fetchPage(1, pageUrls);
      final wallpaperData = Wallpaper(
        page: page,
        pageUrls: pageUrls,
        wallpapers: wallpapers,
      );
      cachedWallpaper = wallpaperData;
      return wallpaperData;
    } else {
      throw Exception('Failed to load HTML');
    }
  }

  Future<List<Map<String, String>>> fetchPage(int page, List<String> pageUrls) async {
    String getUrl = '?boardType=0&searchType=&searchText=&Page=$page';
    final response = await http.get(Uri.parse('$baseUrl$getUrl'));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      var wallpaperList = document.querySelector('#wallpaper_list');
      final wallpapers = wallpaperList!
          .querySelectorAll('li')
          .where((li) => li.querySelector('a')!.attributes.containsKey('attr-img_m'))
          .map((li) {
        final a = li.querySelector('a')!;
        final attrIdx = a.attributes['attr-idx']!;
        final attrImgM = a.attributes['attr-img_m']!;
        final src = a.querySelector('img')!.attributes['src']!;
        return {
          'attr-idx': attrIdx,
          'attr-img_m': attrImgM,
          'src': src,
        };
      }).toList();

      return wallpapers;
    } else {
      throw Exception('Failed to load HTML');
    }
  }

  Future<List<Map<String, String>>> fetchNonMobileWallpapers(int page) async {
    String getUrl = '?boardType=0&searchType=&searchText=&Page=$page';
    final response = await http.get(Uri.parse('$baseUrl$getUrl'));
    if (response.statusCode == 200) {
      final wallpaperListStartIndex = response.body.indexOf('<ul class="wallpaper_list" id="wallpaper_list">') + ('<ul class="wallpaper_list" id="wallpaper_list">').length;
      final wallpaperListEndIndex = response.body.indexOf('</ul>', wallpaperListStartIndex);
      final wallpaperList1 = response.body.substring(wallpaperListStartIndex, wallpaperListEndIndex);

      final wallpaperList = <Map<String, String>>[];
      final wallpaperListItems = wallpaperList1.split('</li>');
      for (final item in wallpaperListItems) {
        final itemTrimmed = item.trim();
        if (itemTrimmed.isEmpty) continue;

        final idxStart = itemTrimmed.indexOf('attr-idx="') + 10;
        final idxEnd = itemTrimmed.indexOf('"', idxStart);
        final imgMStart = itemTrimmed.indexOf('attr-img_m="') + 12;
        final imgMEnd = itemTrimmed.indexOf('"', imgMStart);
        final srcStart = itemTrimmed.indexOf('src="') + 5;
        final srcEnd = itemTrimmed.indexOf('"', srcStart);
        wallpaperList.add({
          'attr-idx': itemTrimmed.substring(idxStart, idxEnd),
          'attr-img_m': itemTrimmed.substring(imgMStart, imgMEnd),
          'src': itemTrimmed.substring(srcStart, srcEnd),
        });
      }

      return wallpaperList;
    } else {
      throw Exception('Failed to load HTML');
    }
  }
}
