import 'package:flutter/material.dart';

enum ArrowDirection { up, down, left, right }

class CoachStep {
  final GlobalKey targetKey;
  final String title;
  final String description;
  final ArrowDirection arrowDirection;

  CoachStep({
    required this.targetKey,
    required this.title,
    required this.description,
    this.arrowDirection = ArrowDirection.down,
  });
}
