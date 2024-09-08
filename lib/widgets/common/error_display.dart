import 'package:flutter/material.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final String errorCode;
  final VoidCallback onRetry;

  const ErrorDisplayWidget({
    Key? key,
    required this.errorCode,
    required this.onRetry,
  }) : super(key: key);

  // Function to map error codes to user-friendly messages in Korean
  String _getErrorMessage(String errorCode) {
    print(errorCode); // Debugging the error code
    if (errorCode.contains('network-request-failed')) {
      return "인터넷 연결이 원활하지 않습니다. 네트워크를 확인한 후 다시 시도해주세요.";
    } else if (errorCode.contains('unauthorized') || errorCode.contains('permission-denied') || errorCode.contains('storage/unauthorized') || errorCode.contains('app-check-error')) {
      return "앱 인증에 실패했습니다. 잠시 후 다시 시도하거나 지원팀에 문의해주세요.";
    } else if (errorCode.contains('storage/object-not-found')) {
      return "요청하신 파일을 찾을 수 없습니다. 파일을 확인한 후 다시 시도해주세요.";
    } else if (errorCode.contains('storage/quota-exceeded')) {
      return "저장소 용량을 초과했습니다. 잠시 후 다시 시도해주세요.";
    } else if (errorCode.contains('storage/retry-limit-exceeded') || errorCode.contains('storage/unknown')) {
      return "서버에 문제가 발생했습니다. 잠시 후 다시 시도해주세요.";
    } else if (errorCode.contains('storage/invalid-checksum')) {
      return "파일 다운로드 링크가 만료되었습니다. 새 링크로 다시 시도해주세요.";
    } else if (errorCode == 'no-games-available') {
      return "현재 이용할 수 있는 게임이 없습니다. 나중에 다시 확인해주세요.";
    } else {
      return "알 수 없는 오류가 발생했습니다. 다시 시도해주세요.";
    }
  }

  @override
  Widget build(BuildContext context) {
    String errorMessage = _getErrorMessage(errorCode);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              '서버와 연결할 수 없습니다.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                backgroundColor: Colors.blueAccent, // Button color
              ),
              child: const Text(
                '다시 시도',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
