import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/game/components/collidables/ground.dart';
import 'package:pixel_adventure/game/components/collidables/platform.dart';
import 'package:pixel_adventure/game/effects/move_effect.dart';

enum ActorMoveState {
  idle,
  running,
}

mixin CanMove on SpriteAnimationGroupComponent {
  double _horizontalMovement = 0;
  double get horizontalMovement => _horizontalMovement;
  set horizontalMovement(value) {
    if (value != _horizontalMovement) {
      _horizontalMovement = value;
    }
  }

  double _moveSpeed = 100;
  double get moveSpeed => _moveSpeed;
  set moveSpeed(value) {
    if (value != _moveSpeed && value > 0) {
      _moveSpeed = value;
    }
  }

  Vector2 _velocity = Vector2.zero();
  Vector2 get velocity => _velocity;
  set velocity(value) {
    if (value != _velocity) {
      _velocity = value;
    }
  }

  bool _isJumping = false;
  bool get isJumping => _isJumping;
  set isJumping(value) {
    if (value != _isJumping) {
      _isJumping = value;
    }
  }

  double get actualXPosition {
    if (isFlippedHorizontally) {
      return position.x + width;
    }
    return position.x;
  }

  void updatePlayerPosition(double dt) {
    velocity = velocity.clone()..x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void updatePlayerMoveAnimation() {
    var playerState = ActorMoveState.idle;

    if (velocity.x < 0 && !isFlippedHorizontally) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && isFlippedHorizontally) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x != 0) {
      playerState = ActorMoveState.running;
    }

    current = playerState;
  }

  void handleJoystickMovement(JoystickDirection direction) {
    switch (direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        horizontalMovement = -1.0;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        horizontalMovement = 1.0;
        break;
      default:
        break;
    }
  }

  void handleKeyboardMovement(Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0.0;

    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    horizontalMovement += isLeftKeyPressed ? -1.0 : 0.0;

    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    horizontalMovement += isRightKeyPressed ? 1.0 : 0.0;

    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      debugPrint('Jump!');
      jump();
    }
  }

  void jump() {
    isJumping = true;
    //jumping is the vector opposite to gravity - thus it has negative value
    final moveEffect =
        JumpEffect(Vector2(0, -50), onJumpEnd: () => isJumping = false);
    add(moveEffect);
  }

  void handleCollision(PositionComponent other) {
    if (anchor != other.anchor) {
      debugPrint(
          'Cannot handle collision - player and object anchors are not the same');
      return;
    }

    //player can be flipped horizontally - getter for x position
    if (other.x <= actualXPosition && other.x + other.width <= actualXPosition) {
      handleRightCollision(other);
    } else if (other.x >= actualXPosition && other.x + other.width >= actualXPosition) {
      handleLeftCollision(other);
    } else if (other.y + other.height <= position.y) {
      handleBottomCollision(other);
    } else if (other.y < position.y + height) {
      handleTopCollision(other);
    }

    velocity = velocity.clone()..x = 0;
  }

  void handleLeftCollision(PositionComponent other) {
    position = position.clone()..x = other.x - other.width;
  }

  void handleRightCollision(PositionComponent other) {
    position = position.clone()..x = other.x + other.width + width;
  }

  void handleBottomCollision(PositionComponent other) {
  }

  void handleTopCollision(PositionComponent other) {
    //debugPrint('Collisoon from top');
    //stay on the block
    ///////!!!!! tutaj ograniczenie, e jeeli gracz jest na wysokosci ziemi to mozna mu ustawic jej pozycje!!!
    //to mozliwe ze rozwiaze ten problem
    if (velocity.y > 0) {
      if (other is Ground == false) debugPrint('Setting player pos first method');
      velocity.y = 0;
      position = position.clone()..y = other.y - width;
    } else if (velocity.y < 0) {
      debugPrint('setting player position to: position.clone()..y = other.y + other.height');
      velocity.y = 0;
      position = position.clone()..y = other.y + other.height;
    }
  }
}
