import 'package:firebase_storage/firebase_storage.dart';

class Game {
  final String title;
  final String thumbnailUrl;
  final Reference wallpapersRef;

  Game({
    required this.title,
    required this.thumbnailUrl,
    required this.wallpapersRef,
  });
}