import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:gamepaper/config/firebase_options.dart'; // FirebaseOptions import

class FirebaseService {
  static Future<void> initialize() async {
    // Firebase 초기화
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // FirebaseOptions 사용
    );

    // Firebase App Check 활성화
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,  // Play Integrity 사용
     );

    // 익명 사용자 로그인
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
