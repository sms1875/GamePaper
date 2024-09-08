import 'package:firebase_storage/firebase_storage.dart';

// 페이지 단위로 월페이퍼를 배치로 가져오는 함수
Future<List<String>> fetchWallpapersBatch(
    List<Reference> items, int page, int wallpapersPerPage) async {
  final int startIndex = (page - 1) * wallpapersPerPage; // 시작 인덱스 계산
  final int endIndex = startIndex + wallpapersPerPage; // 끝 인덱스 계산

  // 페이징 범위 내에서 레퍼런스 목록 추출
  final List<Reference> pageRefs = items.sublist(
    startIndex,
    endIndex > items.length ? items.length : endIndex, // 마지막 인덱스가 범위 초과할 경우 처리
  );

  // 해당 페이지의 월페이퍼 URL들을 가져옴
  return await Future.wait(pageRefs.map((ref) => ref.getDownloadURL()));
}

// 파일 이름에서 숫자를 추출하여 정렬하는 함수
List<Reference> sortItemsByNumber(List<Reference> items) {
  items.sort((a, b) {
    // 파일 이름에서 숫자를 추출하는 정규식
    final RegExp numberRegExp = RegExp(r'(\d+)');
    final int aNumber = int.parse(numberRegExp.firstMatch(a.name)?.group(0) ?? '0');
    final int bNumber = int.parse(numberRegExp.firstMatch(b.name)?.group(0) ?? '0');
    return aNumber.compareTo(bNumber); // 숫자 순으로 정렬
  });
  return items;
}
