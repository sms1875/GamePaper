import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class HeavenBurnsRedWallpaperRepository extends AbstractWallpaperRepository {
  HeavenBurnsRedWallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    selector: '.post-content > ul > li > div.clm-buttons > a',
    attributeName: 'href',
    needsReplace: true,
    replaceFrom: '../../',
    replaceTo: '',
    customFilterCondition: (href) => href.contains('iphone.png'),
    urlPattern: r'^(.*)$',
    urlReplacement: r'https://heaven-burns-red.com/$1',
  );
}