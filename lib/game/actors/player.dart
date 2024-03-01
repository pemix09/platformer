import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/game/actors/actor.dart';
import 'package:pixel_adventure/game/actors/traits/move.dart';
import 'package:pixel_adventure/game/game_characters.dart';

class Player extends Actor with KeyboardHandler {

  Player({super.name = GameCharacters.ninjaFrog, super.position});

  @override
  FutureOr<void> onLoad() async {
    await super.loadMoveAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (isLeftKeyPressed && isRightKeyPressed) {
      actorMoveDirection = ActorMoveDirection.none;
    } else if (isLeftKeyPressed) {
      actorMoveDirection = ActorMoveDirection.left;
    } else if (isRightKeyPressed) {
      actorMoveDirection = ActorMoveDirection.right;
    } else {
      actorMoveDirection = ActorMoveDirection.none;
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
