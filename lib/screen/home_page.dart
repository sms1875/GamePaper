import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/notifier/df_wallpaper_notifier.dart';
import 'package:wallpaper/screen/blackdesert_wallpaper_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            buildButton(context, 'BlackDesert', BlackDesertWallpaperScreen()),
            buildButton(context, 'Dungeon&Fighter', DungeonAndFighterWallpaper()),
            //buildButton(context, 'LeagueOfLegends', LeagueOfLegendsWallpaperScreen()),
            //buildButton(context, 'MapleStory', MapleStoryWallpaperScreen()),
            //buildButton(context, 'LostArk', LostArkWallpaper()),

          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String title, Widget nextPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[300],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/${title.toLowerCase()}.png',
              height: 100,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class DungeonAndFighterWallpaper extends StatelessWidget {
  const DungeonAndFighterWallpaper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<DungeonAndFighterWallpaperNotifier>();
    return Scaffold(
      body: Column(
        children: [
          Text("DungeonAndFighter", style: TextStyle(fontSize: 30)),
        ],
      ),
    );
  }
}