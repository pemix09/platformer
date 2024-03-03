import 'package:flame/components.dart';
import 'package:pixel_adventure/game/components/actors/traits/move.dart';
import 'package:pixel_adventure/game/assets.dart';
import 'package:pixel_adventure/game/config.dart';
import 'package:pixel_adventure/game/pixel_adventure.dart';

abstract class Actor extends SpriteAnimationGroupComponent with CanMove, HasGameRef<PixelAdventure> {

  final String name;

  Actor({required this.name, super.position});
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  Future<void> loadMoveAnimations() async {
    idleAnimation = await _createAnimation(Assets.idleMove, Config.characterIdleAnimationsAmount);
    runningAnimation = await _createAnimation(Assets.runMove, Config.characterRunningAnimationAmount);

    // list of all animations
    animations = {
      ActorMoveState.idle: idleAnimation,
      ActorMoveState.running: runningAnimation,
    };

    //What current animation should be
    current = ActorMoveState.running;
  }

  Future<SpriteAnimation> _createAnimation(String moveName, int amount) async {
    var filePath = 'MainCharacters/$name/$moveName';

    if (!game.images.containsKey(filePath)) {
      await game.images.load(filePath);
    }
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(filePath),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: Config.characterStepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }
}