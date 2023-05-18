import 'package:wallpaper/data/wallpaper.dart';
import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/repository/blackdesert_wallpaper_repository.dart';

class BlackDesertWallpaperProvider extends WallpaperProvider {
  final BlackDesertWallpaperRepository _blackDesertWallpaperRepository = BlackDesertWallpaperRepository();

  @override
  Wallpaper wallpaperPage = Wallpaper(page: 1, pageUrls: [], wallpapers: []);

  @override
  Future<void> update() async {
    setLoading(true);
    try {
      currentPageIndex = 1;
      wallpaperPage = (await _blackDesertWallpaperRepository.fetchBlackDesertWallpaper());
      pageNumbers = List.generate(wallpaperPage.pageUrls.length, (index) => index + 1);
    } catch (e) {
      setError(e);
    }
    notifyListeners();
    setLoading(false);
  }

  @override
  Future<void> fetchPage(int page) async {
    setLoading(true);
    currentPageIndex = page;
    try{
      final result = await _blackDesertWallpaperRepository
          .fetchpage(page, wallpaperPage.pageUrls)
          .catchError((e) => _blackDesertWallpaperRepository.fetchpageOnError(page))
          .catchError((e) => e);
      wallpaperPage = Wallpaper(
          page: page,
          pageUrls: wallpaperPage.pageUrls,
          wallpapers: result);}
    catch(e){
      setError(e);
    }
    notifyListeners();
  }
}
