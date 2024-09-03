import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 네트워크 이미지를 로드하는 유틸리티 함수입니다.
///
/// [imageUrl]로 이미지를 로드하며, `CachedNetworkImage`를 사용해 이미지 캐싱을 지원합니다.
/// 이미지 로딩 실패 시 `Image.network`를 사용하여 이미지를 다시 시도합니다.
/// [fit]는 이미지의 `BoxFit`을 설정합니다. 기본값은 `BoxFit.contain`입니다.
/// [errorWidget]는 이미지 로딩 실패 시 표시할 위젯을 설정할 수 있습니다.
Widget loadNetworkImage(
    String imageUrl, {
      BoxFit fit = BoxFit.contain,
      Widget? errorWidget,
    }) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    fit: fit,
    placeholder: (context, url) => const Center(
      child: CircularProgressIndicator(), // 이미지 로딩 중 스피너 표시
    ),
    errorWidget: (context, url, error) => Image.network(
      imageUrl,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => errorWidget ?? const Icon(Icons.error), // 로딩 실패 시 아이콘 표시
    ),
  );
}
