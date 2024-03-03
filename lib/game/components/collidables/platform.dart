import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

class Platform extends PositionComponent {
  Platform({required super.position, required super.size}) {
    debugMode = kDebugMode;
  }

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());
  }
}