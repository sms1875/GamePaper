import 'package:flutter/material.dart';

class PageNavigation extends StatelessWidget {
  final int currentPage;
  final List<int> pageNumbers;
  final Function(int) onPageChanged;

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
        ...pageNumbers.length < 9
            ? _buildShortPagination()
            : _buildLongPagination(),
        _buildNavigationButton(
          icon: Icons.arrow_forward_ios,
          onPressed: currentPage < pageNumbers.length ? () => onPageChanged(currentPage + 1) : null,
        ),
      ],
    );
  }

  Widget _buildNavigationButton({required IconData icon, VoidCallback? onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: onPressed != null ? Colors.white : Colors.grey),
    );
  }

  List<Widget> _buildShortPagination() {
    return pageNumbers.map((page) => _buildPageNumber(page)).toList();
  }

  List<Widget> _buildLongPagination() {
    List<Widget> items = [];
    if (currentPage > 3) {
      items.add(_buildPageNumber(1));
      items.add(const Text('...', style: TextStyle(color: Colors.white)));
    }

    for (int i = currentPage - 2; i <= currentPage + 2; i++) {
      if (i > 0 && i <= pageNumbers.length) {
        items.add(_buildPageNumber(i));
      }
    }

    if (currentPage < pageNumbers.length - 2) {
      items.add(const Text('...', style: TextStyle(color: Colors.white)));
      items.add(_buildPageNumber(pageNumbers.length));
    }

    return items;
  }

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