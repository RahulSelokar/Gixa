import 'package:Gixa/common/coach_marker/service/coach_service.dart';
import 'package:flutter/material.dart';

class ReplayGuideButton extends StatelessWidget {
  final String screenKey;

  const ReplayGuideButton({super.key, required this.screenKey});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.help_outline),
      title: const Text("Replay App Guide"),
      onTap: () async {
        await CoachService.reset(screenKey);
        Navigator.pop(context);
      },
    );
  }
}
