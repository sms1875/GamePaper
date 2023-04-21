import 'package:html/parser.dart';
import 'package:wallpaper/data/ImageList.dart';
import 'package:http/http.dart' as http;

class WallpaperRepository {

  Future<ImageListPage> fetchImageListPage(int page) async {
    String baseUrl = 'https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/';
    String getUrl = '?boardType=0&searchType=&searchText=&Page=$page';
    final response = await http.get(
      Uri.parse(
        '$baseUrl$getUrl',
      ),
    );
    if (response.statusCode == 200) {
      final document = parse(response.body);
      final paging = document.getElementById('paging');
      final pageUrls = paging
      !.querySelectorAll('a')
          .map((a) => a.attributes['href']!)
          .toSet()
          .toList() ;
      var wallpaperList = document.querySelector('#wallpaper_list');
      final wallpapers = wallpaperList!.querySelectorAll('li').map((li) {
        final a = li.querySelector('a')!;
        final attrIdx = a.attributes['attr-idx']!;
        final attrImg = a.attributes['attr-img']!;
        final attrImgM = a.attributes['attr-img_m']!;
        final src = a.querySelector('img')!.attributes['src']!;
        return {'attr-idx': attrIdx, 'attr-img': attrImg, 'attr-img_m': attrImgM, 'src': src};
      }).toList();

      return ImageListPage(
        page: page,
        pageUrls: pageUrls,
        wallpapers: wallpapers,
      );
    } else {
      throw Exception('Failed to load HTML');
    }
  }

  Future<ImageListPage> fetchWallpaperList(int page) async {
    String baseUrl = 'https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/';
    String getUrl = '?boardType=0&searchType=&searchText=&Page=$page';
    final response = await http.get(
      Uri.parse(
        '$baseUrl$getUrl',
      ),
    );
    if (response.statusCode == 200) {
      final wallpaperListStartIndex =
          response.body.indexOf('<ul class="wallpaper_list" id="wallpaper_list">') +
              ('<ul class="wallpaper_list" id="wallpaper_list">').length;
      final wallpaperListEndIndex =
      response.body.indexOf('</ul>', wallpaperListStartIndex);
      final wallpaperList1 =
      response.body.substring(wallpaperListStartIndex, wallpaperListEndIndex);

      final wallpaperList = <Map<String, String>>[];
      final wallpaperListItems = wallpaperList1.split('</li>');
      for (final item in wallpaperListItems) {
        final itemTrimmed = item.trim();
        if (itemTrimmed.isEmpty) continue;

        final idxStart = itemTrimmed.indexOf('attr-idx="') + 10;
        final idxEnd = itemTrimmed.indexOf('"', idxStart);
        final imgStart = itemTrimmed.indexOf('attr-img="') + 10;
        final imgEnd = itemTrimmed.indexOf('"', imgStart);
        final imgMStart = itemTrimmed.indexOf('attr-img_m="') + 12;
        final imgMEnd = itemTrimmed.indexOf('"', imgMStart);
        final srcStart = itemTrimmed.indexOf('src="') + 5;
        final srcEnd = itemTrimmed.indexOf('"', srcStart);
        wallpaperList.add({
          'attr-idx': itemTrimmed.substring(idxStart, idxEnd),
          'attr-img': itemTrimmed.substring(imgStart, imgEnd),
          'attr-img_m': itemTrimmed.substring(imgMStart, imgMEnd),
          'src': itemTrimmed.substring(srcStart, srcEnd),
        });
      }
      final pageUrls =[""];

      return ImageListPage(
        page: page,
        pageUrls: pageUrls,
        wallpapers: wallpaperList,
      );
    } else {
      throw Exception('Failed to load HTML');
    }
  }
}