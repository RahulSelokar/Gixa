import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CollegeListShimmer extends StatelessWidget {
  final bool isDark;

  const CollegeListShimmer({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final baseColor =
        isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor =
        isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            height: 190,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      _box(56, 56),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          children: [
                            _line(height: 14),
                            const SizedBox(height: 8),
                            _line(height: 12, widthFactor: 0.6),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _line(height: 12),
                  const SizedBox(height: 8),
                  _line(height: 12, widthFactor: 0.8),

                  const Spacer(),

                  Align(
                    alignment: Alignment.center,
                    child: _line(height: 14, widthFactor: 0.3),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _box(double h, double w) {
    return Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  Widget _line({required double height, double widthFactor = 1}) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
