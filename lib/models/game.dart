import 'package:wallpaper/repository/abstract_wallpaper_repository.dart';

class Game {
  final String title;
  final String image;
  final AbstractWallpaperRepository repository;

  Game({required this.title, required this.image, required this.repository});
}