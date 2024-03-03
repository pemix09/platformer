import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/game/components/actors/player.dart';
import 'package:pixel_adventure/game/components/actors/traits/move.dart';
import 'package:pixel_adventure/game/assets.dart';
import 'package:pixel_adventure/game/components/levels/level.dart';

class PixelAdventure extends FlameGame<Level>
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  //faking black bar on left and right to be same color as background of
  //tile map
  Color backgroundColor() => const Color(0xFF211F30);
  late JoystickComponent joystick;

  PixelAdventure()
      : super(
          world: Level(levelName: Assets.level02, player: Player()),
          camera: CameraComponent.withFixedResolution(width: 640, height: 360),
        );

  @override
  FutureOr<void> onLoad() async {
    await loadImagesToCache();
    setupCamera();
    addJoystick();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    world.player.handleJoystickMovement(joystick.direction);
    super.update(dt);
  }

  //loads all the images to cache! Might slow down loading
  Future<void> loadImagesToCache() async {
    final stopWatch = Stopwatch()..start();
    await images.loadAllImages();
    print('Time loading images: ${stopWatch.elapsed}');
    stopWatch.stop();
  }

  void setupCamera() {
    camera.viewfinder.anchor = Anchor.topLeft;
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache(
            'Hud/Knob.png',
          ),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('Hud/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }
}
