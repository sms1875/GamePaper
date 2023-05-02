import 'package:wallpaper/data/wallpaper.dart';
import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/repository/df_wallpaper_repository.dart';

class DungeonAndFighterWallpaperProvider extends WallpaperProvider {
  final DungeonAndFighterWallpaperRepository _dungeonAndFighterWallpaperRepository = DungeonAndFighterWallpaperRepository();

  @override
  DungeonAndFighterWallpaper wallpaperPage = DungeonAndFighterWallpaper(page: 1, pageUrlsList: [], wallpapers: []);

  @override
  Future<void> update() async {
    try {
      wallpaperPage = ( await _dungeonAndFighterWallpaperRepository.fetchDungeonAndFighterWallpaper());
      setLoading(false);
    } catch (e) {
      wallpaperPage =
          DungeonAndFighterWallpaper(page: 1, pageUrlsList: [], wallpapers: []);
      setLoading(false);
      setError(e);
    }
    notifyListeners();
  }

  @override
  Future<void> fetchPage(int page) async {
    currentPageIndex = page;
    try {
      final result = await _dungeonAndFighterWallpaperRepository.fetchPage(
          page, wallpaperPage.pageUrlsList);
      wallpaperPage = DungeonAndFighterWallpaper(
          page: page,
          pageUrlsList: wallpaperPage.pageUrlsList,
          wallpapers: result);
      setLoading(false);
    } catch (e) {
      wallpaperPage = DungeonAndFighterWallpaper(
          page: page, pageUrlsList: [], wallpapers: []);
      setLoading(false);
      setError(e);
    }
    notifyListeners();
  }
}
