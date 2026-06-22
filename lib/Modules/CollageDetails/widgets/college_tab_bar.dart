import 'package:Gixa/Modules/CollageDetails/controller/collage_detail_controller.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/collage_theme.dart';
import 'package:Gixa/common/widgets/primeum_dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CollegeTabs extends GetView<CollegeDetailController> {
  const CollegeTabs({super.key});

  List<String> _getTabs() {
    final college = controller.college.value;
    if (college == null) return [];

    final tabs = <String>[];

    final hasOverview =
        (college.about ?? "").trim().isNotEmpty ||
        (college.contactMobile ?? "").trim().isNotEmpty ||
        (college.contactEmail ?? "").trim().isNotEmpty ||
        (college.website ?? "").trim().isNotEmpty;

    if (hasOverview) {
      tabs.add("Overview");
    }

    if ((college.courses?.ug?.isNotEmpty ?? false) ||
        (college.courses?.pg?.isNotEmpty ?? false)) {
      tabs.add("Courses");
    }

    final hasFees =
        ((college.courses?.ug ?? []).any(
          (c) => c.fee != null && c.fee!.trim().isNotEmpty,
        ) ||
        (college.courses?.pg ?? []).any(
          (c) => c.fee != null && c.fee!.trim().isNotEmpty,
        ));

    if (hasFees) {
      tabs.add("Fees");
    }

    if ((college.seatMatrix ?? []).isNotEmpty) {
      tabs.add("Seats Matrix");
    }

    tabs.add("Cutoffs");

    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    final colors = CollegeTheme.colors(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.cardBackgroundSoft,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.border),
      ),
      child: SizedBox(
        height: 52,
        child: Obx(() {
          final tabs = _getTabs();
          String selectedTab = controller.selectedTabIndex.value;

          if (!tabs.contains(selectedTab)) {
            selectedTab = tabs.first;

            controller.selectedTabIndex.value = selectedTab;
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            itemCount: tabs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final label = tabs[index];
              final isSelected = selectedTab == label;
              final isPremium = label.contains("Cutoffs");
              return GestureDetector(
                onTap: () {
                  if (label == "Cutoffs 🔒") {
                    Future.microtask(() {
                      if (Get.isDialogOpen != true) {
                        showPremiumLockDialog(context);
                      }
                    });

                    return;
                  }

                  controller.changeTab(label);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected ? colors.brandGradient : null,
                    color: isSelected ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: isSelected ? colors.floatingShadow : [],
                  ),
                  child: Row(
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : colors.textSub,
                        ),
                      ),
                      if (isPremium) ...[
                        const SizedBox(width: 6),
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 14,
                          color: isSelected
                              ? Colors.white.withOpacity(0.92)
                              : colors.textMuted,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
