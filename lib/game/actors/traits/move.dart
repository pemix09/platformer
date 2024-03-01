import 'package:flame/components.dart';

enum ActorMoveState {
  idle,
  running,
}

enum ActorMoveDirection {
  left,
  right,
  none,
}

mixin CanMove on SpriteAnimationGroupComponent {
  ActorMoveDirection actorMoveDirection = ActorMoveDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  void updatePlayerMovement(double dt) {
    double directionX = 0.0;
    switch(actorMoveDirection) {
      case ActorMoveDirection.left:
        if (!isFlippedHorizontally) {
          flipHorizontallyAroundCenter();
        }
        current = ActorMoveState.running;
        directionX -= moveSpeed;
        break;
      case ActorMoveDirection.right:
        if (isFlippedHorizontally) {
          flipHorizontallyAroundCenter();
        }
        current = ActorMoveState.running;
        directionX += moveSpeed;
        break;
      default:
        current = ActorMoveState.idle;
        break;
    }
    velocity = Vector2(directionX, 0.0);
    position += velocity * dt;
  }
}