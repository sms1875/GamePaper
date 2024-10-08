import 'package:flutter/material.dart';
import 'package:gamepaper/repositories/game_repository.dart';
import 'package:provider/provider.dart';
import 'package:gamepaper/providers/home_provider.dart';
import 'package:gamepaper/screens/home_screen.dart';
import 'package:gamepaper/services/firebase_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider(repository: GameRepository())),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Game Paper',
        home: HomeScreen(),
      ),
    );
  }
}