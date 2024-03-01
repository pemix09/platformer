import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/game/actors/player.dart';
import 'package:pixel_adventure/game/assets.dart';
import 'package:pixel_adventure/game/config.dart';
import 'package:pixel_adventure/game/pixel_adventure.dart';
import 'package:pixel_adventure/game/game_characters.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  final String levelName;
  final Player player;

  Level({required this.levelName, required this.player});

  late final TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    await loadLevel();
    spawnCharacters();
    return super.onLoad();
  }

  Future<void> loadLevel() async {
    level =
        await TiledComponent.load(levelName, Vector2.all(Config.tileSize));
    add(level);
  }

  void spawnCharacters() {
    final spawnPointsLayer =
        level.tileMap.getLayer<ObjectGroup>('Spawn Points');

    if (spawnPointsLayer == null) {
      throw Exception('Couldn\'t find required layer!');
    }

    for (final spawnPoint in spawnPointsLayer.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);
          break;
      }
    }
  }
}
