import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:pixel_adventure/game/actors/player.dart';
import 'package:pixel_adventure/game/assets.dart';
import 'package:pixel_adventure/game/levels/level.dart';

class PixelAdventure extends FlameGame<Level> with HasKeyboardHandlerComponents {

  @override
  //faking black bar on left and right to be same color as background of
  //tile map
  Color backgroundColor() => const Color(0xFF211F30);

  PixelAdventure()
      : super(
          world: Level(levelName: Assets.level02, player: Player()),
          camera: CameraComponent.withFixedResolution(width: 640, height: 360),
        );

  @override
  FutureOr<void> onLoad() async {

    //function below loads all the images to cache! Might slow down loading
    final stopWatch = Stopwatch()..start();
    await images.loadAllImages();
    print('Time loading images: ${stopWatch.elapsed}');
    camera.viewfinder.anchor = Anchor.topLeft;
    debugPrint('Game has been loaded!');
    return super.onLoad();
  }
}
