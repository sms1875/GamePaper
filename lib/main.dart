import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wallpaper/repository/blackdesert_wallpaper_repository.dart';
import 'package:wallpaper/notifier/wallpaper_notifier.dart';
import 'package:wallpaper/screen/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BlackDesertWallpaperRepository>(
          create: (_) => BlackDesertWallpaperRepository(),
        ),
        ChangeNotifierProxyProvider<BlackDesertWallpaperRepository, WallpaperNotifier>(
          create: (_) => WallpaperNotifier(),
          update: (_, repository, notifier) => notifier!..update(repository),
        ),
      ],
      child: const MaterialApp(
        title: 'Wallpaper Changer',
        home: HomePage(),
      ),
    );
  }
}