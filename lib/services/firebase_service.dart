import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wallpaper/config/firebase_options.dart';

class FirebaseService {
  static Future<void> initialize() async {
    await dotenv.load(fileName: 'assets/config/.env');
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
  }

  static Future<void> _ensureAuthenticated() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      await auth.signInAnonymously();
    }
  }
}