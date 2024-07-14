import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class ElderScrollsOnlineWallpaperRepository extends AbstractWallpaperRepository {
  ElderScrollsOnlineWallpaperRepository(String baseUrl)
      : super(
    baseUrl: baseUrl,
    selector: '#media-category > div > section > a[data-zl-title*="750x1334"]',
    attributeName: 'data-zl-title',
  );

  @override
  String? extractHref(element) {
    final title = element.attributes['data-zl-title'];
    if (title == null) return null;
    final parts = title.split('|');
    for (var part in parts) {
      part = part.trim();
      if (part.contains('750x1334')) {
        return part.substring(part.indexOf('\'')+1, part.lastIndexOf('target'));
      }
    }
    return null;
  }
}