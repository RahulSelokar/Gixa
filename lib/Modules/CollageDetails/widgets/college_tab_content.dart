import 'package:Gixa/Modules/CollageDetails/controller/collage_detail_controller.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:Gixa/Modules/subscription/features/feature_names.dart';
import 'package:Gixa/Modules/subscription/extensions/subscription_tier_extension.dart';
import 'package:Gixa/common/widgets/primeum_dailog.dart';
import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/about_section.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/collage_theme.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/college_cutoff_tab.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/contact_card.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/course_section.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/seat_graph_section.dart';
import 'package:Gixa/Modules/seatMatrix/controller/seat_matrix_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollegeTabContent extends GetView<CollegeDetailController> {
  final CollegeDetail college;

  SeatMatrixController get _seatController => Get.find<SeatMatrixController>();

  const CollegeTabContent({super.key, required this.college});

  @override
  Widget build(BuildContext context) {
    final colors = CollegeTheme.colors(context);

    return Obx(() {
      final tabs = _getTabs();
      if (tabs.isEmpty) {
        return const SizedBox.shrink();
      }

      String selectedTab = controller.selectedTabIndex.value;

      if (!tabs.contains(selectedTab)) {
        selectedTab = tabs.first;

        controller.selectedTabIndex.value = selectedTab;
      }

      final Widget content;

      switch (selectedTab) {
        case 'Overview':
          content = _overview();
          break;
        case 'Courses':
          content = _courses();
          break;
        case 'Fees':
          content = _fees(colors);
          break;
        case 'Seats Matrix':
          content = _seatGraphTab(colors);
          break;
        case 'Cutoffs':
          content = _cutoffs(context);
          break;
        default:
          content = const SizedBox.shrink();
      }

      return SizedBox(width: double.infinity, child: content);
    });
  }

  Widget _fees(CollegeThemeColors colors) {
    final ug = college.courses.ug;
    final pg = college.courses.pg;

    if ((ug.isEmpty) && (pg.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ug.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'UG Courses',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 8),
          ...ug.map(
            (c) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      c.name,
                      style: TextStyle(color: colors.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    c.fee != null && c.fee!.trim().isNotEmpty
                        ? c.fee!
                        : 'Not available',
                    style: TextStyle(color: colors.textSub),
                  ),
                ],
              ),
            ),
          ),
        ],

        if (pg.isNotEmpty) ...[
          const SizedBox(height: 18),
          Text(
            'PG Courses',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 8),
          ...pg.map(
            (c) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      c.courseName,
                      style: TextStyle(color: colors.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    c.fee != null && c.fee!.trim().isNotEmpty
                        ? c.fee!
                        : 'Not available',
                    style: TextStyle(color: colors.textSub),
                  ),
                ],
              ),
            ),
          ),
        ],

        const SizedBox(height: 24),
      ],
    );
  }

  List<String> _getTabs() {
    final tabs = <String>[];

    final hasOverview =
        (college.about).trim().isNotEmpty ||
        college.contactMobile.trim().isNotEmpty ||
        college.contactEmail.trim().isNotEmpty ||
        college.website.trim().isNotEmpty;

    if (hasOverview) {
      tabs.add('Overview');
    }

    if (college.courses.ug.isNotEmpty || college.courses.pg.isNotEmpty) {
      tabs.add('Courses');
    }

    final hasFees =
        ((college.courses.ug).any(
          (c) => c.fee != null && c.fee!.trim().isNotEmpty,
        ) ||
        (college.courses.pg).any(
          (c) => c.fee != null && c.fee!.trim().isNotEmpty,
        ));

    if (hasFees) {
      tabs.add('Fees');
    }

    if (college.seatMatrix.isNotEmpty) {
      tabs.add('Seats Matrix');
    }

    tabs.add('Cutoffs');
    return tabs;
  }

  Widget _overview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (college.about.trim().isNotEmpty) AboutSection(college: college),
        if (college.about.trim().isNotEmpty) const SizedBox(height: 20),
        if (college.contactMobile.trim().isNotEmpty ||
            college.contactEmail.trim().isNotEmpty ||
            college.website.trim().isNotEmpty)
          ContactCard(college: college),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _courses() {
    if (college.courses.ug.isEmpty && college.courses.pg.isEmpty) {
      return const SizedBox.shrink();
    }

    return CoursesSection(college: college);
  }

  Widget _seatGraphTab(CollegeThemeColors colors) {
    return Obx(() {
      final fetchedSeatMatrix = _seatController.getSeatsForCollege(
        college.name,
      );
      final seatMatrix = fetchedSeatMatrix.isNotEmpty
          ? fetchedSeatMatrix
          : college.seatMatrix;

      if (_seatController.isLoading.value && seatMatrix.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: CircularProgressIndicator(color: colors.primary),
          ),
        );
      }

      return SeatGraphTab(
        seatMatrix: seatMatrix,
        instituteType: college.instituteType,
        collegeName: college.name,
      );
    });
  }

  Widget _cutoffs(BuildContext context) {
    final subscriptionController = Get.find<SubscriptionController>();
    // Check if user can access cutoff feature
    final canAccessCutoff = subscriptionController.canAccessFeature(
      FeatureNames.cutoff,
    );
    if (canAccessCutoff) {
      return CollegeCutoffTab(collegeId: college.id);
    } else {
      // Show the premium dialog and return an empty widget
      Future.microtask(() => showPremiumLockDialog(context));
      return const SizedBox.shrink();
    }
  }
}
