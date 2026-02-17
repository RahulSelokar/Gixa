// import 'package:Gixa/common/widgets/primeum_dailog.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:Gixa/Modules/CollageDetails/controller/collage_detail_controller.dart';
// import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
// import 'package:Gixa/Modules/CollageDetails/widgets/about_section.dart';
// import 'package:Gixa/Modules/CollageDetails/widgets/ai_match_card.dart';
// import 'package:Gixa/Modules/CollageDetails/widgets/contact_card.dart';
// import 'package:Gixa/Modules/CollageDetails/widgets/college_facilities.dart';
// import 'package:Gixa/Modules/CollageDetails/widgets/college_location_map.dart';
// import 'package:Gixa/Modules/CollageDetails/widgets/course_section.dart';
// import 'package:Gixa/Modules/CollageDetails/widgets/stats_grid.dart';

// class CollegeTabContent extends GetView<CollegeDetailController> {
//   final CollegeDetail college;

//   const CollegeTabContent({
//     super.key,
//     required this.college,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       switch (controller.selectedTabIndex.value) {
//         case 0:
//           return _overview();
//         case 1:
//           return _courses();
//         case 2:
//           return _fees();
//         case 3:
//           return _cutoffs();
//         case 4:
//           return _reviews();
//         default:
//           return const SizedBox();
//       }
//     });
//   }

//   // ───────────────── OVERVIEW TAB ─────────────────

//   Widget _overview() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const AIMatchCard(),
//         const SizedBox(height: 24),
//         AboutSection(college: college),
//         const SizedBox(height: 20),
//         StatsGrid(college: college),
//         const SizedBox(height: 24),
//         ContactCard(college: college),
//         const SizedBox(height: 24),
//         FacilitiesSection(college: college),
//         const SizedBox(height: 24),
//         const LocationMap(),
//       ],
//     );
//   }

//   // ───────────────── COURSES TAB ─────────────────

//   Widget _courses() {
//     return CoursesSection(college: college);
//   }

//   // ───────────────── PLACEHOLDERS ─────────────────

//   Widget _fees() {
//     return PremiumLockDialog();
//   }

//   Widget _cutoffs() {
//     return PremiumLockDialog();
//   }

//   Widget _reviews() {
//     return const Center(child: Text("Reviews coming soon"));
//   }
// }



import 'package:Gixa/common/widgets/primeum_dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:Gixa/Modules/CollageDetails/controller/collage_detail_controller.dart';
import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/about_section.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/ai_match_card.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/contact_card.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/college_facilities.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/college_location_map.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/course_section.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/stats_grid.dart';

class CollegeTabContent extends GetView<CollegeDetailController> {
  final CollegeDetail college;

  const CollegeTabContent({
    super.key,
    required this.college,
  });

  @override
  Widget build(BuildContext context) {
    // We handle padding here to ensure all tabs align perfectly
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Obx(() {
        switch (controller.selectedTabIndex.value) {
          case 0:
            return _overview(context);
          case 1:
            return _courses();
          case 2:
            return _fees(context);
          case 3:
            return _cutoffs(context);
          case 4:
            return _reviews(context);
          default:
            return const SizedBox();
        }
      }),
    );
  }

  // ───────────────── OVERVIEW TAB ─────────────────

  Widget _overview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AIMatchCard(),
        const SizedBox(height: 24),
        AboutSection(college: college),
        const SizedBox(height: 20),
        StatsGrid(college: college),
        const SizedBox(height: 24),
        ContactCard(college: college),
        const SizedBox(height: 24),
        FacilitiesSection(college: college),
        const SizedBox(height: 24),
        const LocationMap(),
      ],
    );
  }

  // ───────────────── COURSES TAB ─────────────────

  Widget _courses() {
    return CoursesSection(college: college);
  }

  // ───────────────── PREMIUM TABS (FEES & CUTOFFS) ─────────────────

  Widget _fees(BuildContext context) {
    // return _buildPremiumPlaceholder(
    //   context,
    //   title: "Fee Structure Locked",
    //   description: "Unlock detailed fee breakdown for all courses, hostel fees, and hidden charges.",
    //   icon: Icons.monetization_on_outlined,
    // );

    return PremiumLockDialog();
  }

  Widget _cutoffs(BuildContext context) {
    // return _buildPremiumPlaceholder(
    //   context,
    //   title: "Previous Year Cutoffs",
    //   description: "Get access to last 5 years' cutoff trends for JEE, NEET, and Board exams.",
    //   icon: Icons.trending_up_rounded,
    // );
    return PremiumLockDialog();
  }

  // ───────────────── REVIEWS TAB ─────────────────

  Widget _reviews(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800]!.withOpacity(0.5) : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rate_review_rounded,
              size: 40,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "No Reviews Yet",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Be the first one to review this college!",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── REUSABLE PREMIUM CARD UI ─────────────────

  Widget _buildPremiumPlaceholder(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? const Color(0xFF333333) : Colors.grey.shade200;
    final textColor = isDark ? Colors.white : const Color(0xFF111111);
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Premium Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_person_rounded,
              color: const Color(0xFFF59E0B),
              size: 32,
            ),
          ),
          const SizedBox(height: 24),
          
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          
          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: subTextColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Show the Dialog when clicked
                Get.dialog(const PremiumLockDialog());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2979FF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stars_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Unlock Now",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}