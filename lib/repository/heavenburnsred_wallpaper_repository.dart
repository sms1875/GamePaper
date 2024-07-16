import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class HeavenBurnsRedWallpaperRepository extends BaseWallpaperRepository {
  HeavenBurnsRedWallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    imageElementSelector: '.post-content > ul > li > div.clm-buttons > a',
    imageAttributeName: 'href',
    pageUrlPattern: RegExp(r'^../../'),
    pageUrlReplacement: '',
    pagingUrlFilter: (href) => href.contains('iphone.png'),
    imageUrlPrefix: 'https://heaven-burns-red.com/',
  );
}