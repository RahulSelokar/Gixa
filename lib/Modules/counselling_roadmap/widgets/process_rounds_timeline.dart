import 'package:flutter/material.dart';
import '../model/counselling_state_model.dart';
import 'shared_widgets.dart';

class ProcessRoundsTimeline extends StatelessWidget {
  final List<RoundProcessData> rounds;
  final bool isDark;
  final Color borderColor;

  const ProcessRoundsTimeline({
    super.key,
    required this.rounds,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (rounds.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12, right: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "CAP COUNSELING ROUNDS",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: GixaColors.orange,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.swipe_outlined,
                      size: 14,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Swipe",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward,
                      size: 12,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(rounds.length * 2 - 1, (index) {
                if (index.isOdd) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: GixaColors.orange.withOpacity(0.5)),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: GixaColors.orange,
                        ),
                      ),
                    ),
                  );
                }

                final roundIndex = index ~/ 2;
                return _RoundCard(
                  round: rounds[roundIndex],
                  isDark: isDark,
                  borderColor: borderColor,
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoundCard extends StatelessWidget {
  final RoundProcessData round;
  final bool isDark;
  final Color borderColor;

  const _RoundCard({
    required this.round,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280, // Fixed width for each card
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: CounsellingUi.cardShadow(isDark),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Thick Border
          Container(
            height: 6,
            width: double.infinity,
            color: round.themeColor,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: round.themeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    round.badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  round.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : GixaColors.ink,
                  ),
                ),
                const SizedBox(height: 16),
                // Steps
                ...round.steps.map((step) => _buildStepItem(step)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(RoundStepData step) {
    if (step.type == RoundStepType.normal) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text("→", style: TextStyle(color: GixaColors.orange, fontSize: 16)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                step.text,
                style: TextStyle(
                  fontSize: 13.5,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Highligted steps (Warning or Error)
    final isError = step.type == RoundStepType.error;
    final color = isError ? Colors.red : GixaColors.orange;
    final icon = isError ? Icons.block : Icons.warning_amber_rounded;
    final bgColor = isError ? Colors.red.withOpacity(0.1) : GixaColors.orange.withOpacity(0.1);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              step.text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
