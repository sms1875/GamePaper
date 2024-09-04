import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/providers/home_provider.dart';
import 'package:wallpaper/providers/wallpaper_provider.dart';
import 'package:wallpaper/screens/home_screen.dart';
import 'package:wallpaper/screens/wallpaper_screen.dart';
import 'package:wallpaper/services/firebase_service.dart';

import 'models/game.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Game Paper',
        home: HomeScreen(),
      ),
    );
  }
}