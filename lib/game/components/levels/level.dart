import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/game/components/actors/player.dart';
import 'package:pixel_adventure/game/components/collidables/ground.dart';
import 'package:pixel_adventure/game/components/collidables/platform.dart';
import 'package:pixel_adventure/game/components/collidables/terrain_object.dart';
import 'package:pixel_adventure/game/components/collidables/wall.dart';
import 'package:pixel_adventure/game/config.dart';
import 'package:pixel_adventure/game/pixel_adventure.dart';
import 'package:pixel_adventure/game/game_characters.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  final String levelName;
  final Player player;

  Level({required this.levelName, required this.player});

  late final TiledComponent level;
  final platforms = <Platform>[];
  final walls = <Wall>[];
  final terrainObjects = <TerrainObject>[];
  final grounds = <Ground>[];
  final gravity = 9.8;

  //max velocity - when the air friction doesn't allow us to go faster
  final double terminalVelocity = 300;

  @override
  FutureOr<void> onLoad() async {
    await loadLevel();
    spawnCharacters();
    addCollidableObjects();
    return super.onLoad();
  }

  Future<void> loadLevel() async {
    level = await TiledComponent.load(levelName, Vector2.all(Config.tileSize));
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

  void addCollidableObjects() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer == null) {
      throw Exception('Couldn\'t have found collision layer!');
    }

    for (final colObject in collisionsLayer.objects) {
      switch (colObject.class_) {
        case 'Platform':
          final platform = Platform(
            position: Vector2(colObject.x, colObject.y),
            size: Vector2(colObject.width, colObject.height),
          );
          platforms.add(platform);
          break;
        case 'Terrain':
          final terrainObject = TerrainObject(
            position: Vector2(colObject.x, colObject.y),
            size: Vector2(colObject.width, colObject.height),
          );
          terrainObjects.add(terrainObject);
          break;
        case 'Wall':
          final wall = Wall(
            position: Vector2(colObject.x, colObject.y),
            size: Vector2(colObject.width, colObject.height),
          );
          walls.add(wall);
          break;
        case 'Ground':
          final ground = Ground(
            position: Vector2(colObject.x, colObject.y),
            size: Vector2(colObject.width, colObject.height),
          );
          grounds.add(ground);
          break;
      }
    }

    addAll(platforms);
    addAll(walls);
    addAll(terrainObjects);
    addAll(grounds);
  }
}
