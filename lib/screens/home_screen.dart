import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/models/game.dart';
import 'package:wallpaper/providers/home_provider.dart';
import 'package:wallpaper/widgets/home/alphabet_game_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          if (homeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (homeProvider.gameMap.isEmpty) {
            return const Center(child: Text('No games available'));
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