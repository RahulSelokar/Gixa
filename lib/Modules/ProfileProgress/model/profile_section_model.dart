import 'package:flutter/material.dart';

class ProfileSectionCard {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final String image;
  final int? boostPercent;
  final String? actionLabel;

  ProfileSectionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.image,
    this.boostPercent,
    this.actionLabel,
  });
}