import 'package:Gixa/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppSnackbarType { success, error, warning, info }

class AppSnackbar {
  AppSnackbar._();

  static void show(
    String title,
    String message, {
    SnackPosition snackPosition = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? colorText,
    EdgeInsets? margin,
    Widget? icon,
  }) {
    final context = Get.context;
    if (context == null) return;

    final resolvedTitle = title.trim();
    final resolvedMessage = message.trim();
    if (resolvedTitle.isEmpty && resolvedMessage.isEmpty) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final type = _resolveType(resolvedTitle, resolvedMessage);
    final palette = _paletteFor(
      type,
      isDark,
      backgroundColor: backgroundColor,
      colorText: colorText,
    );
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            elevation: 0,
            backgroundColor: Colors.transparent,
            duration: duration,
            padding: EdgeInsets.zero,
            margin:
                margin ??
                const EdgeInsets.fromLTRB(16, 0, 16, 16),
            content: _AppSnackbarCard(
              title: resolvedTitle,
              message: resolvedMessage,
              icon: icon,
              palette: palette,
              type: type,
            ),
          ),
        );
    });
  }

  static void success(String title, String message, {Duration? duration}) {
    show(title, message, duration: duration ?? const Duration(seconds: 3));
  }

  static void error(String title, String message, {Duration? duration}) {
    show(title, message, duration: duration ?? const Duration(seconds: 3));
  }

  static void warning(String title, String message, {Duration? duration}) {
    show(title, message, duration: duration ?? const Duration(seconds: 3));
  }

  static void info(String title, String message, {Duration? duration}) {
    show(title, message, duration: duration ?? const Duration(seconds: 3));
  }

  static AppSnackbarType _resolveType(String title, String message) {
    final combined = '${title.toLowerCase()} ${message.toLowerCase()}';

    if (combined.contains('success') ||
        combined.contains('verified') ||
        combined.contains('activated') ||
        combined.contains('sent') ||
        combined.contains('created')) {
      return AppSnackbarType.success;
    }

    if (combined.contains('warning') ||
        combined.contains('locked') ||
        combined.contains('premium') ||
        combined.contains('incomplete')) {
      return AppSnackbarType.warning;
    }

    if (combined.contains('error') ||
        combined.contains('failed') ||
        combined.contains('invalid') ||
        combined.contains('unable') ||
        combined.contains('could not')) {
      return AppSnackbarType.error;
    }

    return AppSnackbarType.info;
  }

  static _SnackbarPalette _paletteFor(
    AppSnackbarType type,
    bool isDark, {
    Color? backgroundColor,
    Color? colorText,
  }) {
    if (backgroundColor != null || colorText != null) {
      final resolvedBackground = backgroundColor ??
          (isDark ? const Color(0xFF201A2E) : Colors.white);
      final resolvedText = colorText ??
          (isDark ? Colors.white : const Color(0xFF1E293B));

      return _SnackbarPalette(
        accent: _accentFor(type),
        background: resolvedBackground,
        backgroundSoft: resolvedBackground.withOpacity(0.94),
        titleColor: resolvedText,
        messageColor: resolvedText.withOpacity(0.92),
        borderColor: resolvedBackground.withOpacity(0.28),
      );
    }

    switch (type) {
      case AppSnackbarType.success:
        return _SnackbarPalette(
          accent: const Color(0xFF14B87A),
          background: isDark ? const Color(0xFF162A24) : Colors.white,
          backgroundSoft:
              isDark ? const Color(0xFF1D342D) : const Color(0xFFF1FFF8),
          titleColor:
              isDark ? const Color(0xFFEFFFF7) : const Color(0xFF113B2A),
          messageColor:
              isDark ? const Color(0xFFC4ECDC) : const Color(0xFF3C6A58),
          borderColor: const Color(0xFF14B87A).withOpacity(0.20),
        );
      case AppSnackbarType.error:
        return _SnackbarPalette(
          accent: const Color(0xFFE85D75),
          background: isDark ? const Color(0xFF2B1820) : Colors.white,
          backgroundSoft:
              isDark ? const Color(0xFF351E28) : const Color(0xFFFFF4F6),
          titleColor:
              isDark ? const Color(0xFFFFEFF3) : const Color(0xFF4D1F2A),
          messageColor:
              isDark ? const Color(0xFFF0C7D0) : const Color(0xFF80515A),
          borderColor: const Color(0xFFE85D75).withOpacity(0.20),
        );
      case AppSnackbarType.warning:
        return _SnackbarPalette(
          accent: UColors.primary,
          background: isDark ? const Color(0xFF2A1E15) : Colors.white,
          backgroundSoft:
              isDark ? const Color(0xFF35261A) : const Color(0xFFFFF7EE),
          titleColor:
              isDark ? const Color(0xFFFFF4E6) : const Color(0xFF5C3610),
          messageColor:
              isDark ? const Color(0xFFF4D9B8) : const Color(0xFF8A5A2B),
          borderColor: UColors.primary.withOpacity(0.22),
        );
      case AppSnackbarType.info:
        return _SnackbarPalette(
          accent: UColors.secondary,
          background: isDark ? const Color(0xFF172234) : Colors.white,
          backgroundSoft:
              isDark ? const Color(0xFF1C2940) : const Color(0xFFF4F8FF),
          titleColor:
              isDark ? const Color(0xFFF0F6FF) : const Color(0xFF1E3558),
          messageColor:
              isDark ? const Color(0xFFC6D8F6) : const Color(0xFF58749B),
          borderColor: UColors.secondary.withOpacity(0.20),
        );
    }
  }

  static Color _accentFor(AppSnackbarType type) {
    switch (type) {
      case AppSnackbarType.success:
        return const Color(0xFF14B87A);
      case AppSnackbarType.error:
        return const Color(0xFFE85D75);
      case AppSnackbarType.warning:
        return UColors.primary;
      case AppSnackbarType.info:
        return UColors.secondary;
    }
  }
}

class _SnackbarPalette {
  final Color accent;
  final Color background;
  final Color backgroundSoft;
  final Color titleColor;
  final Color messageColor;
  final Color borderColor;

  const _SnackbarPalette({
    required this.accent,
    required this.background,
    required this.backgroundSoft,
    required this.titleColor,
    required this.messageColor,
    required this.borderColor,
  });
}

class _AppSnackbarCard extends StatelessWidget {
  final String title;
  final String message;
  final Widget? icon;
  final _SnackbarPalette palette;
  final AppSnackbarType type;

  const _AppSnackbarCard({
    required this.title,
    required this.message,
    required this.icon,
    required this.palette,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 5,
              height: 80,
              color: palette.accent,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      palette.background,
                      palette.backgroundSoft,
                    ],
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: palette.accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: icon ??
                            _DefaultSnackbarIcon(
                              color: palette.accent,
                              type: type,
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title.isNotEmpty)
                            Text(
                              title,
                              style: GoogleFonts.inter(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: palette.titleColor,
                                height: 1.25,
                              ),
                            ),
                          if (title.isNotEmpty && message.isNotEmpty)
                            const SizedBox(height: 4),
                          if (message.isNotEmpty)
                            Text(
                              message,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: palette.messageColor,
                                height: 1.35,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DefaultSnackbarIcon extends StatelessWidget {
  final Color color;
  final AppSnackbarType type;

  const _DefaultSnackbarIcon({
    required this.color,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      AppSnackbarType.success => Icons.check_circle_rounded,
      AppSnackbarType.error => Icons.error_rounded,
      AppSnackbarType.warning => Icons.warning_amber_rounded,
      AppSnackbarType.info => Icons.info_rounded,
    };

    return Icon(icon, color: color, size: 22);
  }
}
