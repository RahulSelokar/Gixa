import 'package:Gixa/Modules/CollageDetails/controller/collage_detail_controller.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/bottom_appbar.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/collage_header.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/collage_theme.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/college_app_bar.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/college_hero_image.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/college_tab_bar.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/college_tab_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollegeDetailPage extends StatelessWidget {
  CollegeDetailPage({super.key});

  final CollegeDetailController controller = Get.put(CollegeDetailController());

  @override
  Widget build(BuildContext context) {
    final colors = CollegeTheme.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CollegeAppBar(controller: controller),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: colors.pageBackgroundGradient),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: colors.primary),
            );
          }

          final college = controller.college.value;
          print("Courses from backend: ${college?.courses}");
          if (college == null) {
            return Center(
              child: Text(
                'no_data_found'.tr,
                style: TextStyle(
                  color: colors.textSub,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return Stack(
            children: [
              Positioned(
                top: -110,
                right: -80,
                child: _BackgroundGlow(
                  size: 240,
                  colors: [
                    colors.primary.withOpacity(0.18),
                    colors.pink.withOpacity(0.05),
                  ],
                ),
              ),
              Positioned(
                top: 220,
                left: -90,
                child: _BackgroundGlow(
                  size: 210,
                  colors: [
                    colors.purple.withOpacity(0.14),
                    colors.secondary.withOpacity(0.05),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 130),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CollegeHeroImage(college: college),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          CollegeHeaderSection(college: college),
                          const SizedBox(height: 18),
                          const CollegeTabs(),
                          const SizedBox(height: 16),
                          CollegeTabContent(college: college),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomActionBar(college: college),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  final double size;
  final List<Color> colors;

  const _BackgroundGlow({required this.size, required this.colors});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }
}
