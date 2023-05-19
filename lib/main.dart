import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/provider/apexlegends_wallpaper_provider.dart';
import 'package:wallpaper/provider/blackdesert_wallpaper_provider.dart';
import 'package:wallpaper/provider/df_wallpaper_provider.dart';
import 'package:wallpaper/provider/eldenring_wallpaper_provider.dart';
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
        ChangeNotifierProvider(create: (_) => BlackDesertWallpaperProvider()),
        ChangeNotifierProvider(create: (_) => DungeonAndFighterWallpaperProvider()),
        ChangeNotifierProvider(create: (_) => ApexLegendsWallpaperProvider()),
        ChangeNotifierProvider(create: (_) => EldenRingWallpaperProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wallpaper Changer',
        home: HomePage(),
      ),
    );
  }
}
