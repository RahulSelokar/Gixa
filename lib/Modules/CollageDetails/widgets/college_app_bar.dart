import 'package:Gixa/Modules/CollageDetails/controller/collage_detail_controller.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/collage_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CollegeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CollegeDetailController controller;

  const CollegeAppBar({super.key, required this.controller});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = CollegeTheme.colors(context);

    return AppBar(
      backgroundColor: colors.appBarBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: colors.appBarGradient),
      ),
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: colors.subtleBorder, height: 1),
      ),
      leadingWidth: 68,
      leading: IconButton(
        onPressed: Get.back,
        tooltip: "Back",
        icon: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: colors.softFill(colors.primary, lightOpacity: 0.10, darkOpacity: 0.18),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.subtleBorder),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colors.textMain,
            size: 18,
          ),
        ),
      ),
      centerTitle: true,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: colors.warmGradient,
              borderRadius: BorderRadius.circular(999),
              boxShadow: colors.floatingShadow,
            ),
            child: Text(
              "GIXA AI VERIFIED",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.7,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Obx(() {
            final name = controller.college.value?.name ?? "College Details";
            return Text(
              name,
              style: GoogleFonts.inter(
                color: colors.textMain,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }),
        ],
      ),
    );
  }
}
