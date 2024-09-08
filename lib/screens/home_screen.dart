import 'package:flutter/material.dart';
import 'package:gamepaper/widgets/common/error_display.dart';
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
  String? selectedAlphabet;

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
            return const Center(child: CircularProgressIndicator());
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
                isSelected: selectedAlphabet == alphabet,
                onAlphabetTap: () {
                  setState(() {
                    selectedAlphabet = (selectedAlphabet == alphabet) ? null : alphabet;
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
