import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieErrorView extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onRetry;

  const LottieErrorView({
    super.key,
    this.title = "Something went wrong",
    this.subtitle = "Please try again later",
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 360),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.surface
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🎬 LOTTIE ANIMATION
              Lottie.asset(
                'assets/lottie/error.json',
                width: 200,
                repeat: true,
              ),

              const SizedBox(height: 16),

              /// ❌ TITLE
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              /// ℹ️ SUBTITLE
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),

              if (onRetry != null) ...[
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text("Try Again"),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
