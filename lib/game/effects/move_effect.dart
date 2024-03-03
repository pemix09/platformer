import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

class JumpEffect extends MoveByEffect {
  JumpEffect(Vector2 moveVector, {void Function()? onJumpEnd})
      : super(
          moveVector,
          EffectController(
            duration: 0.2,
            curve: Curves.ease,
            onMax: onJumpEnd,
          ),
        );
}
