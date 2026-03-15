import 'package:flutter/material.dart';
import 'package:gamepaper/repositories/game_repository.dart';
import 'package:provider/provider.dart';
import 'package:gamepaper/providers/home_provider.dart';
import 'package:gamepaper/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase 초기화 제거 — Sprint 2: 서버 REST API로 전환
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => HomeProvider(repository: GameRepository())),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Game Paper',
        home: HomeScreen(),
      ),
    );
  }
}
