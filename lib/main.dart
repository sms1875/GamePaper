import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/providers/home_provider.dart';
import 'package:wallpaper/repositories/game_repository.dart';
import 'package:wallpaper/screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load(fileName: 'assets/config/.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Activate Firebase App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  // Ensure the user is signed in
  await _ensureAuthenticated();

  final gameRepository = GameRepository(FirebaseStorage.instance);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider(gameRepository)),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _ensureAuthenticated() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  user ??= (await auth.signInAnonymously()).user;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Paper',
      home: HomeScreen(),
    );
  }
}