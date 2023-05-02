import 'package:wallpaper/data/wallpaper.dart';
import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/repository/blackdesert_wallpaper_repository.dart';

class BlackDesertWallpaperProvider extends WallpaperProvider {
  final BlackDesertWallpaperRepository _blackDesertWallpaperRepository = BlackDesertWallpaperRepository();

  @override
  Wallpaper get wallpaperPage => _wallpaperPage;
  Wallpaper _wallpaperPage = Wallpaper(page: 1, pageUrls: [], wallpapers: []);

  @override
  Future<void> update() async {
    try {
      _wallpaperPage = (await _blackDesertWallpaperRepository.fetchBlackDesertWallpaper());

      setLoading(false);
    } catch (e) {
      _wallpaperPage = Wallpaper(page: 1, pageUrls: [], wallpapers: []);
      setLoading(false);
      setError(e);
    }
    notifyListeners();
  }

  @override
  Future<void> fetchPage(int page) async {
    currentPageIndex = page;
    try{
      final result = await _blackDesertWallpaperRepository
          .fetchpage(page, wallpaperPage.pageUrls)
          .catchError((e) => _blackDesertWallpaperRepository.fetchpageOnError(page))
          .catchError((e) => e);
      _wallpaperPage = Wallpaper(
          page: page,
          pageUrls: wallpaperPage.pageUrls,
          wallpapers: result);}
    catch(e){
      setLoading(false);
      setError(e);
    }
    notifyListeners();
  }
}
