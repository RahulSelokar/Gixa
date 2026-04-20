import 'package:Gixa/Modules/CollageDetails/controller/collage_detail_controller.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/bottom_appbar.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/collage_header.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/college_app_bar.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/college_hero_image.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/college_tab_bar.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/college_tab_content.dart';
import 'package:Gixa/Modules/seatMatrix/controller/seat_matrix_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollegeDetailPage extends StatelessWidget {
  CollegeDetailPage({super.key});

  final CollegeDetailController controller = Get.put(CollegeDetailController());

  final SeatMatrixController seatController = Get.find<SeatMatrixController>();

  // 🎨 Brand Color
  static const Color kPrimaryBlue = Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: CollegeAppBar(controller: controller),
      body: Obx(() {
        // ⏳ Loading state
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: kPrimaryBlue));
        }

        final college = controller.college.value;

        // ❌ No data
        if (college == null) {
          return Center(child: Text('no_data_found'.tr));
        }

        return Stack(
          children: [
            /// 📜 Scrollable Content
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🖼️ Hero Image (Gallery-based)
                  CollegeHeroImage(college: college),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        /// 🏫 College Header
                        CollegeHeaderSection(college: college),

                        const SizedBox(height: 16),

                        /// 📑 Tabs + Content
                        Column(
                          children: const [CollegeTabs(), SizedBox(height: 12)],
                        ),

                        CollegeTabContent(college: college),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// 🦶 Bottom Action Bar
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomActionBar(college: college),
            ),
          ],
        );
      }),
    );
  }
}
