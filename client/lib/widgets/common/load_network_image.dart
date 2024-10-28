import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

/// 네트워크 이미지를 로드하는 유틸리티 함수입니다.
/// BlurHash를 이용하여 로딩 중에 BlurHash 이미지를 표시합니다.
Widget loadNetworkImage(
    String imageUrl, {
      String? blurHash,
      BoxFit fit = BoxFit.contain,
      Widget? errorWidget,
    }) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    fit: fit,
    placeholder: (context, url) => blurHash != null
        ? BlurHash(
      hash: blurHash,
      imageFit: BoxFit.cover,
    )
        : const Center(child: CircularProgressIndicator()), // BlurHash가 없으면 로딩 중 스피너 표시
    errorWidget: (context, url, error) => errorWidget ?? const Icon(Icons.error),
  );
}
