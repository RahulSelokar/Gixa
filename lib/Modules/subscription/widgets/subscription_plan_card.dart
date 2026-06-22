import 'package:Gixa/Modules/subscription/model/subscription_plan.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:flutter/material.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final VoidCallback onSubscribe;

  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    final isBest = plan.bestValue;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: isBest
            ? LinearGradient(
                colors: [kHomeAccentColor, const Color(0xFFD97706)],
              )
            : const LinearGradient(
                colors: [Color(0xFF0E1626), Color(0xFF0B1220)],
              ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 30),
        ],
        border: Border.all(color: isBest ? kHomeAccentColor : Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Text(
                plan.planName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (isBest)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: kHomeAccentColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "BEST VALUE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          /// PRICE
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "₹${plan.amount}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: " /month",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          /// FEATURES
          ...plan.features.map(
            (f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    f.isEnabled ? Icons.check_circle : Icons.lock_outline,
                    color: f.isEnabled
                        ? (isBest ? Colors.white : Colors.greenAccent)
                        : Colors.redAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      f.featureTitle,
                      style: TextStyle(
                        color: f.isEnabled ? Colors.white : Colors.white54,
                        fontSize: 15,
                        fontWeight: f.isEnabled
                            ? FontWeight.normal
                            : FontWeight.w300,
                        decoration: f.isEnabled
                            ? null
                            : TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 22),

          /// BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSubscribe,
              style: ElevatedButton.styleFrom(
                backgroundColor: isBest ? Colors.white : Colors.transparent,
                foregroundColor: isBest ? kHomeAccentColor : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: isBest
                      ? BorderSide.none
                      : const BorderSide(color: Colors.white30),
                ),
              ),
              child: const Text(
                "Subscribe Now",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
