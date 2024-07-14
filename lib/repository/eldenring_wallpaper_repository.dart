import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class EldenRingWallpaperRepository extends AbstractWallpaperRepository {
  EldenRingWallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    selector: '#specialCol > ul.wpList > li > p > a',
    attributeName: 'href',
    needsReplace: true,
    replaceFrom: '../../',
    replaceTo: '',
    customFilterCondition: (href) => href.contains('1125x2436'),
    urlPattern: r'^(.*)$',
    urlReplacement: r'https://eldenring.bn-ent.net/$1',
  );
}