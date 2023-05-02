import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/notifier/df_wallpaper_notifier.dart';
import 'package:wallpaper/repository/blackdesert_wallpaper_repository.dart';
import 'package:wallpaper/notifier/blackdesert_wallpaper_notifier.dart';
import 'package:wallpaper/repository/df_wallpaper_repository.dart';
import 'package:wallpaper/screen/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => BlackDesertWallpaperNotifier()..update()),
        ChangeNotifierProvider(
          create: (_) => DungeonAndFighterWallpaperNotifier()..update(),
        ),
      ],
      child: const MaterialApp(
        title: 'Wallpaper Changer',
        home: HomePage(),
      ),
    );
  }
}
