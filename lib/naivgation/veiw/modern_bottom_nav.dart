import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:Gixa/Modules/choice_filling/controller/predication_sheet_controller.dart';

class ModernBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ModernBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Brand Color
  final Color kPrimaryBlue = kHomeAccentColor;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);

    // Initialize the prediction sheet controller globally so we can check for new sheets
    final predictionController = Get.isRegistered<PredictionSheetController>()
        ? Get.find<PredictionSheetController>()
        : Get.put(PredictionSheetController());

    final Color navBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color inactiveIconColor = isDark
        ? Colors.grey[400]!
        : Colors.grey[400]!;
    final Color borderColor = isDark ? Colors.grey[800]! : Colors.transparent;

    final List<BoxShadow> shadows = isDark
        ? []
        : [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: kPrimaryBlue.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ];
    final bottomInset = mediaQuery.viewPadding.bottom;
    final bottomSpacing = bottomInset > 0 ? bottomInset : 10.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(8, 10, 8, bottomSpacing),
      decoration: BoxDecoration(
        color: navBgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: shadows,
      ),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// HOME
            _buildNavItem(
              0,
              Icons.home_rounded,
              Icons.home_outlined,
              "Home",
              inactiveIconColor,
            ),

            // /// COUNSELLING
            // Obx(() => _buildNavItem(
            //   1,
            //   Icons.support_agent_rounded,
            //   Icons.support_agent_outlined,
            //   "Counselling",
            //   inactiveIconColor,
            //   showBadge: predictionController.sheets.isNotEmpty,
            // )),

            /// COLLEGES
            _buildNavItem(
              2,
              Icons.account_balance_rounded,
              Icons.account_balance_outlined,
              "Colleges",
              inactiveIconColor,
            ),

            /// ACCOUNT
            _buildNavItem(
              3,
              Icons.person_rounded,
              Icons.person_outline_rounded,
              "Account",
              inactiveIconColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
    Color inactiveColor, {
    bool showBadge = false,
  }) {
    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? kPrimaryBlue.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Icon
            Badge(
              isLabelVisible: showBadge,
              backgroundColor: Colors.red,
              smallSize: 8,
              child: Icon(
                isSelected ? activeIcon : inactiveIcon,
                color: isSelected ? kPrimaryBlue : inactiveColor,
                size: 26,
              ),
            ),

            // Text Label (Animated width)
            ClipRRect(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: isSelected ? 82 : 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: kPrimaryBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

