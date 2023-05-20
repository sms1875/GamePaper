import 'package:wallpaper/data/wallpaper.dart';
import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/repository/df_wallpaper_repository.dart';

class DungeonAndFighterWallpaperProvider extends WallpaperProvider {
  final DungeonAndFighterWallpaperRepository _dungeonAndFighterWallpaperRepository = DungeonAndFighterWallpaperRepository();

  @override
  Wallpaper wallpaperPage = Wallpaper(page: 1, pageUrlsList: [], wallpapers: []);

  @override
  Future<void> update() async {
    setLoading(true);
    try {
      currentPageIndex = 1;
      wallpaperPage = await _dungeonAndFighterWallpaperRepository.fetchWallpaper();
      pageNumbers = List.generate(wallpaperPage.pageUrlsList.length, (index) => index + 1);
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
    try {
      final result = await _dungeonAndFighterWallpaperRepository.fetchPage(
          page, wallpaperPage.pageUrlsList);
      wallpaperPage = Wallpaper(
          page: page,
          pageUrlsList: wallpaperPage.pageUrlsList,
          wallpapers: result);
    } catch (e) {
      setError(e);
    }
    notifyListeners();
  }
}
