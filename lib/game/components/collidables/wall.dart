import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

class Wall extends PositionComponent {
  Wall({required super.position, required super.size}) {
    debugMode = kDebugMode;
  }

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());
  }
}