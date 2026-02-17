import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.transparent,

        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor:
            theme.colorScheme.onSurface.withOpacity(0.45),

        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
        ),

        items: [
          _navItem(
            icon: EvaIcons.homeOutline,
            activeIcon: Icons.home_rounded,
            label: "Home",
            isActive: currentIndex == 0,
            theme: theme,
          ),
          _navItem(
            icon: Icons.school_outlined,
            activeIcon: Icons.school_rounded,
            label: "Colleges",
            isActive: currentIndex == 1,
            theme: theme,
          ),
          _navItem(
            icon: Icons.person_outline,
            activeIcon: EvaIcons.person,
            label: "Profile",
            isActive: currentIndex == 2,
            theme: theme,
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _navItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    required ThemeData theme,
  }) {
    return BottomNavigationBarItem(
      label: label,
      icon: _NavIcon(
        icon: icon,
        isActive: false,
        theme: theme,
      ),
      activeIcon: _NavIcon(
        icon: activeIcon,
        isActive: true,
        theme: theme,
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final ThemeData theme;

  const _NavIcon({
    required this.icon,
    required this.isActive,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.all(isActive ? 8 : 6),
      decoration: BoxDecoration(
        color: isActive
            ? primary.withOpacity(0.15)
            : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: AnimatedScale(
        scale: isActive ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Icon(
          icon,
          size: isActive ? 26 : 24,
          color: isActive
              ? primary
              : theme.colorScheme.onSurface.withOpacity(0.55),
        ),
      ),
    );
  }
}
