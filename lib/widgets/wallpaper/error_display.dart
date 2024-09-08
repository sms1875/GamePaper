import 'package:flutter/material.dart';

/// 에러 발생 시 사용자에게 표시하는 위젯입니다.
///
/// [onRetry] 콜백을 전달하여 사용자가 'Retry' 버튼을 클릭하면
/// 에러를 해결할 수 있도록 다시 시도할 수 있습니다.
class ErrorDisplay extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorDisplay({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          const Text(
            'An error occurred while fetching wallpapers.',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry, // 재시도 콜백 실행
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
