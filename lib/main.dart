import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/game/pixel_adventure.dart';

//Stopwatch to measure how much time user is playing
final stopwatch = Stopwatch();

Future<void> main() async {
  stopwatch.start();
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('Time loading binding: ${stopwatch.elapsed}');
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  debugPrint('Time elapsed loading flame: ${stopwatch.elapsed}');

  var game = PixelAdventure();
  runApp(
    //code below will recreate PixelAdventure game every time we hit hot reload, super useful!
    GameWidget(game: kDebugMode ? PixelAdventure() : game),
  );
}
