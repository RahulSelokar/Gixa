import 'package:flutter/material.dart';

class CoachTarget extends StatelessWidget {
  final GlobalKey coachKey;
  final Widget child;

  const CoachTarget({
    super.key,
    required this.coachKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(key: coachKey, child: child);
  }
}
