import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/counselling_state_model.dart';
import '../widgets/shared_widgets.dart';
import '../controller/counselling_roadmap_controller.dart';

class StateSelector extends StatelessWidget {
  final CounsellingRoadmapController controller;
  final bool isDark;
  final Color borderColor;

  const StateSelector({
    required this.controller,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = CounsellingUi.cardBg(context, isDark);

    return Obx(() {
      final states = controller.currentStates;
      return SizedBox(
        height: 104,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 2),
          itemCount: states.length,
          clipBehavior: Clip.none,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final state = states[index];
            final bool isSelected =
                controller.selectedStateIndex.value == index;

            // Clean gradient-ring technique: outer gradient container with 1.6px
            // padding wraps an inner solid card.
            return GestureDetector(
              onTap: () => controller.selectState(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                width: 128,
                padding: EdgeInsets.all(isSelected ? 1.6 : 0),
                decoration: BoxDecoration(
                  gradient: isSelected ? GixaColors.primaryGradient : null,
                  color: isSelected ? null : cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected ? null : Border.all(color: borderColor),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: GixaColors.pink.withOpacity(0.30),
                            blurRadius: 16,
                            spreadRadius: -2,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : CounsellingUi.cardShadow(isDark),
                ),
                child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius:
                        BorderRadius.circular(isSelected ? 14.4 : 16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient:
                              isSelected ? GixaColors.primaryGradient : null,
                          color: isSelected ? null : GixaColors.pinkLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          state.icon,
                          size: 17,
                          color: isSelected ? Colors.white : GixaColors.pink,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        state.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: CounsellingUi.textPrimary(isDark),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${state.totalRounds} Rounds",
                        style: TextStyle(
                          fontSize: 10.5,
                          color: isSelected
                              ? GixaColors.pink
                              : Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}