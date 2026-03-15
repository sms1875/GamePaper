class Game {
  final int id;
  final String name;
  final int wallpaperCount;
  final String status;

  Game({
    required this.id,
    required this.name,
    required this.wallpaperCount,
    required this.status,
  });

  factory Game.fromServerJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as int,
      name: json['name'] as String,
      wallpaperCount: json['wallpaperCount'] as int? ?? 0,
      status: json['status'] as String? ?? 'ACTIVE',
    );
  }
}

class Wallpaper {
  final int id;
  final String url;
  final String? blurHash;
  final int width;
  final int height;

  Wallpaper({
    required this.id,
    required this.url,
    this.blurHash,
    this.width = 0,
    this.height = 0,
  });

  factory Wallpaper.fromServerJson(Map<String, dynamic> json) {
    return Wallpaper(
      id: json['id'] as int? ?? 0,
      url: json['url'] as String,
      blurHash: json['blurHash'] as String?,
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
    );
  }
}
