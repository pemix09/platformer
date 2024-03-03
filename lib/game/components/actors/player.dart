import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/game/components/actors/actor.dart';
import 'package:pixel_adventure/game/components/collidables/ground.dart';
import 'package:pixel_adventure/game/components/collidables/platform.dart';
import 'package:pixel_adventure/game/components/collidables/terrain_object.dart';
import 'package:pixel_adventure/game/components/collidables/wall.dart';
import 'package:pixel_adventure/game/game_characters.dart';

class Player extends Actor with KeyboardHandler, CollisionCallbacks {

  Player({super.name = GameCharacters.ninjaFrog, super.position});

  final double jumpForce = 460;

  @override
  FutureOr<void> onLoad() async {
    debugMode = kDebugMode;
    await super.loadMoveAnimations();
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.updatePlayerPosition(dt);
    super.updatePlayerMoveAnimation();
    applyGravity(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    handleKeyboardMovement(keysPressed);
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Ground == false) {
      debugPrint('Type oof other: $other');
    }
    handleCollision(other);
    super.onCollision(intersectionPoints, other);
  }

  void applyGravity(double dt) {
    velocity.y += game.world.gravity;
    velocity.y = velocity.y.clamp(-game.world.gravity, game.world.terminalVelocity);
    position.y += velocity.y * dt;
  }
}
