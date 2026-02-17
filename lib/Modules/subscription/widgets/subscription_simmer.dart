import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SubscriptionPlanCardShimmer extends StatelessWidget {
  const SubscriptionPlanCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor =
        isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor =
        isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: baseColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                _box(width: 80, height: 16),
                const Spacer(),
                _box(width: 70, height: 20, radius: 20),
              ],
            ),

            const SizedBox(height: 18),

            /// PRICE
            _box(width: 140, height: 36),

            const SizedBox(height: 20),

            /// FEATURES (4 lines)
            ...List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    _circle(size: 20),
                    const SizedBox(width: 12),
                    Expanded(child: _box(height: 14)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// BUTTON
            _box(height: 48, radius: 30),
          ],
        ),
      ),
    );
  }

  /// 🔹 Helpers
  Widget _box({
    double height = 14,
    double width = double.infinity,
    double radius = 6,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _circle({double size = 20}) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
