import 'package:flutter/material.dart';
import 'package:wallpaper/models/game.dart';
import 'package:wallpaper/widgets/home/game_carousel.dart';
import 'package:wallpaper/widgets/home/game_list_view.dart';

/// AlphabetGameSection 위젯
///
/// 이 위젯은 특정 알파벳으로 시작하는 게임들의 섹션을 표시합니다.
/// 알파벳 헤더와 게임 목록 또는 캐러셀을 포함합니다.
///
/// [alphabet]: 섹션의 알파벳
/// [games]: 해당 알파벳으로 시작하는 게임 목록
/// [isSelected]: 현재 섹션이 선택되었는지 여부
/// [onAlphabetTap]: 알파벳 헤더를 탭했을 때 실행할 콜백
class AlphabetGameSection extends StatelessWidget {
  final String alphabet;
  final List<Game> games;
  final bool isSelected;
  final VoidCallback onAlphabetTap;

  const AlphabetGameSection({
    Key? key,
    required this.alphabet,
    required this.games,
    required this.isSelected,
    required this.onAlphabetTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAlphabetHeader(),
          if (isSelected)
            GameListView(games: games)
          else
            GameCarousel(games: games),
        ],
      ),
    );
  }

  /// 알파벳 헤더를 생성하는 메서드
  ///
  /// 탭 가능한 알파벳 텍스트를 생성합니다.
  /// 선택 여부에 따라 텍스트 색상이 변경됩니다.
  Widget _buildAlphabetHeader() {
    return GestureDetector(
      onTap: onAlphabetTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Text(
          alphabet.toUpperCase(),
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}