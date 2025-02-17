import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'dart:math';

import '../brick_breaker.dart';
import 'bat.dart';
import 'brick.dart';
import 'play_area.dart';

class Ball extends CircleComponent with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Ball({
    required this.velocity,
    required super.position,
    required double radius,
    required this.difficultyModifier,
  }) : super(
            radius: radius,
            anchor: Anchor.center,
            paint: Paint()
              ..color = const Color(0xff1e6091)
              ..style = PaintingStyle.fill,
            children: [CircleHitbox()]);

  final Vector2 velocity;
  final double difficultyModifier;

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  int rng() {
    final random = Random();
    return random.nextInt(4) + 1; // Menghasilkan angka acak antara 1 hingga 4
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayArea) {
      if (intersectionPoints.first.y <= 0) {
        velocity.y = -velocity.y;
      } else if (intersectionPoints.first.x <= 0) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.x >= game.width) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.y >= game.height) {
        add(RemoveEffect(
            delay: 0.35,
            onComplete: () {
              game.playState = PlayState.gameOver;
            }));
      }
    } else if (other is Bat) {
      velocity.y = -velocity.y;
      velocity.x = velocity.x +
          (position.x - other.position.x) / other.size.x * game.width * 0.3;
    } else if (other is Brick) {
      if (position.y < other.position.y - other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.y > other.position.y + other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.x < other.position.x) {
        velocity.x = -velocity.x;
      } else if (position.x > other.position.x) {
        velocity.x = -velocity.x;
      }

      switch (rng()) {
        case 1:
          FlameAudio.play('audio_soloud_step_06_assets_sounds_pew1 (1).mp3');
          break;
        case 2:
          FlameAudio.play('audio_soloud_step_06_assets_sounds_pew1 (1).mp3');
          break;
        case 3:
          FlameAudio.play('audio_soloud_step_06_assets_sounds_pew1 (1).mp3');
          break;
        case 4:
          FlameAudio.play('audio_soloud_step_06_assets_sounds_pew1 (1).mp3');
          break;
        default:
          FlameAudio.play('audio_soloud_step_06_assets_sounds_pew1 (1).mp3');
      }

      velocity.setFrom(velocity * difficultyModifier);
    }
  }
}
