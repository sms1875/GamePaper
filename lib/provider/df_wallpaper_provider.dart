import 'package:wallpaper/data/wallpaper.dart';
import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/repository/df_wallpaper_repository.dart';

class DungeonAndFighterWallpaperProvider extends WallpaperProvider {
  final DungeonAndFighterWallpaperRepository _dungeonAndFighterWallpaperRepository = DungeonAndFighterWallpaperRepository();

  @override
  DungeonAndFighterWallpaper wallpaperPage = DungeonAndFighterWallpaper(page: 1, pageUrlsList: [], wallpapers: []);

  @override
  Future<void> update() async {
    setLoading(true);
    try {
      wallpaperPage = ( await _dungeonAndFighterWallpaperRepository.fetchDungeonAndFighterWallpaper());
    } catch (e) {
      setError(e);
    }
    setLoading(false);
    notifyListeners();
  }

  @override
  Future<void> fetchPage(int page) async {
    setLoading(true);
    currentPageIndex = page;
    try {
      final result = await _dungeonAndFighterWallpaperRepository.fetchPage(
          page, wallpaperPage.pageUrlsList);
      wallpaperPage = DungeonAndFighterWallpaper(
          page: page,
          pageUrlsList: wallpaperPage.pageUrlsList,
          wallpapers: result);
    } catch (e) {
      setError(e);
    }
    notifyListeners();
  }
}
