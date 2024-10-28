import 'package:firebase_storage/firebase_storage.dart';

class Game {
  final String title;
  final Wallpaper thumbnail;
  final Reference wallpapersRef;

  Game({
    required this.title,
    required this.thumbnail,
    required this.wallpapersRef,
  });
}

class Wallpaper {
  final String url;
  final String? blurHash; // Optional blurHash field

  Wallpaper({
    required this.url,
    this.blurHash,
  });
}