import 'dart:ui';
import 'package:flutter/material.dart';

class RegistrationSuccessDialog extends StatelessWidget {
  final String firstName;
  final int airRank;
  final VoidCallback onContinue;

  const RegistrationSuccessDialog({
    Key? key,
    required this.firstName,
    required this.airRank,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onContinue();
        return false;
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: onContinue,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/congrats_genie.png',
                  width: MediaQuery.of(context).size.width * 0.90,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
