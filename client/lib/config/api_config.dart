/// 서버 API 기본 URL 설정
///
/// 에뮬레이터: http://10.0.2.2:8080
/// 실기기 (로컬 네트워크): http://{서버_로컬_IP}:8080
/// 예: flutter run --dart-define=API_BASE_URL=http://192.168.1.100:8080
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static String gamesUrl() => '$baseUrl/api/games';

  static String wallpapersUrl(int gameId, {int page = 0, int size = 12}) =>
      '$baseUrl/api/wallpapers/$gameId?page=$page&size=$size';
}
