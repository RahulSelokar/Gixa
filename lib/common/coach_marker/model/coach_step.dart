import 'package:flutter/material.dart';

enum ArrowDirection { up, down, left, right }

class CoachStep {
  final GlobalKey targetKey;
  final String title;
  final String description;
  final String? imageAsset;
  final ArrowDirection arrowDirection;
  final double scrollAlignment;
  final Duration scrollDuration;

  CoachStep({
    required this.targetKey,
    required this.title,
    required this.description,
    this.imageAsset,
    this.arrowDirection = ArrowDirection.down,
    this.scrollAlignment = 0.18,
    this.scrollDuration = const Duration(milliseconds: 420),
  });
}
