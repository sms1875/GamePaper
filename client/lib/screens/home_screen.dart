import 'package:flutter/material.dart';
import 'package:gamepaper/widgets/common/error_display.dart';
import 'package:gamepaper/widgets/common/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:gamepaper/models/game.dart';
import 'package:gamepaper/providers/home_provider.dart';
import 'package:gamepaper/widgets/home/alphabet_game_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Set<String>으로 변경하여 여러 개의 알파벳을 동시에 선택할 수 있도록 함
  Set<String> selectedAlphabets = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).loadGames();
    });
  }

  // Retry function
  void _retryLoadingGames(BuildContext context) {
    Provider.of<HomeProvider>(context, listen: false).loadGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          if (homeProvider.isLoading) {
            return const Center(child: LoadingWidget());
          } else if (homeProvider.errorMessage.isNotEmpty || homeProvider.gameMap.isEmpty) {
            // If there is an error message or no games available, show the error state
            return ErrorDisplayWidget(
              error: homeProvider.errorMessage.isNotEmpty
                  ? homeProvider.errorMessage
                  : "no-games-available", // Custom error code for no games
              onRetry: () => _retryLoadingGames(context),
            );
          }

          final gameMap = homeProvider.gameMap;
          return ListView.builder(
            itemCount: gameMap.length,
            itemBuilder: (BuildContext context, int index) {
              final String alphabet = gameMap.keys.elementAt(index);
              final List<Game> gamesByAlphabet = gameMap[alphabet]!;

              return AlphabetGameSection(
                alphabet: alphabet,
                games: gamesByAlphabet,
                isSelected: selectedAlphabets.contains(alphabet),
                onAlphabetTap: () {
                  setState(() {
                    if (selectedAlphabets.contains(alphabet)) {
                      selectedAlphabets.remove(alphabet); // 이미 선택된 경우 해제
                    } else {
                      selectedAlphabets.add(alphabet); // 선택되지 않은 경우 추가
                    }
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
