import 'package:flutter/material.dart';

/// 페이지 네비게이션을 제공하는 위젯입니다.
///
/// 이 위젯은 페이지 번호와 이전/다음 버튼을 포함하여 페이지 변경을 관리합니다.
/// [currentPage]는 현재 페이지 번호를 나타내며, [pageNumbers]는 전체 페이지 번호 리스트를 포함합니다.
/// [onPageChanged]는 페이지가 변경될 때 호출되는 콜백 함수입니다.
class PageNavigation extends StatelessWidget {
  /// 현재 페이지 번호입니다.
  final int currentPage;

  /// 전체 페이지 번호 리스트입니다.
  final List<int> pageNumbers;

  /// 페이지가 변경될 때 호출되는 콜백 함수입니다.
  final Function(int) onPageChanged;

  /// 생성자
  const PageNavigation({
    Key? key,
    required this.currentPage,
    required this.pageNumbers,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNavigationButton(
          icon: Icons.arrow_back_ios,
          onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        ..._buildPageNumberWidgets(),
        _buildNavigationButton(
          icon: Icons.arrow_forward_ios,
          onPressed: currentPage < pageNumbers.length ? () => onPageChanged(currentPage + 1) : null,
        ),
      ],
    );
  }

  /// 페이지 네비게이션 버튼을 생성합니다.
  ///
  /// [icon]은 버튼에 표시될 아이콘을 설정하며, [onPressed]는 버튼 클릭 시 호출되는 함수입니다.
  Widget _buildNavigationButton({required IconData icon, VoidCallback? onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: onPressed != null ? Colors.white : Colors.grey),
    );
  }

  /// 페이지 번호 위젯들을 생성합니다.
  ///
  /// 페이지 번호가 적으면 전체 페이지 번호를 표시하고,
  /// 페이지 번호가 많으면 현재 페이지를 중심으로 페이지 번호를 표시합니다.
  List<Widget> _buildPageNumberWidgets() {
    return pageNumbers.length < 9
        ? _buildShortPagination()
        : _buildLongPagination();
  }

  /// 페이지 번호가 적을 때 전체 페이지 번호를 표시합니다.
  List<Widget> _buildShortPagination() {
    return pageNumbers.map((page) => _buildPageNumber(page)).toList();
  }

  /// 페이지 번호가 많을 때 현재 페이지를 중심으로 페이지 번호를 표시합니다.
  List<Widget> _buildLongPagination() {
    List<Widget> items = [];

    // 시작 페이지와 중간 생략 기호 추가
    if (currentPage > 3) {
      items.add(_buildPageNumber(1));
      items.add(const Text('...', style: TextStyle(color: Colors.white)));
    }

    // 현재 페이지를 중심으로 주변 페이지 번호 추가
    for (int i = currentPage - 2; i <= currentPage + 2; i++) {
      if (i > 0 && i <= pageNumbers.length) {
        items.add(_buildPageNumber(i));
      }
    }

    // 끝 페이지와 생략 기호 추가
    if (currentPage < pageNumbers.length - 2) {
      items.add(const Text('...', style: TextStyle(color: Colors.white)));
      items.add(_buildPageNumber(pageNumbers.length));
    }

    return items;
  }

  /// 개별 페이지 번호를 표시하는 위젯을 생성합니다.
  ///
  /// [page]는 페이지 번호를 나타내며, 현재 페이지와 일치하면 강조 표시됩니다.
  Widget _buildPageNumber(int page) {
    return GestureDetector(
      onTap: () => onPageChanged(page),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '$page',
          style: TextStyle(
            color: currentPage == page ? Colors.blue : Colors.white,
            fontWeight: currentPage == page ? FontWeight.bold : FontWeight.normal,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
