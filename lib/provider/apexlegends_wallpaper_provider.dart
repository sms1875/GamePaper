import 'package:wallpaper/data/wallpaper.dart';
import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/repository/apexlegends_wallpaper_repository.dart';

class ApexLegendsWallpaperProvider extends WallpaperProvider {
  final ApexLegendsWallpaperRepository _apexLegendsWallpaperRepository = ApexLegendsWallpaperRepository();

  @override
  PagingWallpaper wallpaperPage = PagingWallpaper(page: 1, pageUrlsList: [], wallpapers: []);

  @override
  Future<void> update() async {
    setLoading(true);
    try {
      currentPageIndex = 1;
      wallpaperPage = ( await _apexLegendsWallpaperRepository.fetchApexLegendsWallpaper());
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
      final result = await _apexLegendsWallpaperRepository.fetchPage(
          page, wallpaperPage.pageUrlsList);
      wallpaperPage = PagingWallpaper(
          page: page,
          pageUrlsList: wallpaperPage.pageUrlsList,
          wallpapers: result);
    } catch (e) {
      setError(e);
    }
    notifyListeners();
  }
}
