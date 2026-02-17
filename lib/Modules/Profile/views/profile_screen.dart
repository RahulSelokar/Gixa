import 'dart:io';
import 'package:Gixa/naivgation/controller/nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController profileController = Get.find<ProfileController>();

  final MainNavController navController = Get.find<MainNavController>();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    profileController.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Modern background colors
    final backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF2F2F7);
    final surfaceColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "My Profile",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [_buildActionButton(context, primaryColor)],
      ),
      body: Obx(() {
        final profile = profileController.profile.value;

        if (profileController.isLoading.value && profile == null) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }

        if (profile == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: theme.disabledColor),
                const SizedBox(height: 16),
                Text(
                  "Could not load profile",
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: profileController.refreshProfile,
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: profileController.refreshProfile,
          color: primaryColor,
          child: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              navController.updateScroll(notification.direction);
              return false;
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                // 1. Profile Image & Name
                _buildHeader(context, isDark, surfaceColor, primaryColor),

                const SizedBox(height: 12),

                // 2. NEW: Rank & Score Summary Boxes
                _buildPerformanceSummary(
                  context,
                  isDark,
                  surfaceColor,
                  profile,
                ),

                const SizedBox(height: 16),

                // 3. Personal Info
                _buildSectionTitle(context, "Personal Information"),
                _buildSectionContainer(
                  isDark,
                  surfaceColor,
                  children: [
                    _buildRow(
                      context,
                      Icons.person_outline,
                      "First Name",
                      profileController.firstNameCtrl,
                    ),
                    _buildDivider(isDark),
                    _buildRow(
                      context,
                      Icons.person_outline,
                      "Last Name",
                      profileController.lastNameCtrl,
                    ),
                    _buildDivider(isDark),
                    _buildRow(
                      context,
                      Icons.location_on_outlined,
                      "Address",
                      profileController.addressCtrl,
                    ),
                    _buildDivider(isDark),
                    _buildRow(
                      context,
                      Icons.calendar_today_outlined,
                      "Date of Birth",
                      profileController.dobCtrl,
                    ),
                    _buildDivider(isDark),
                    _buildRow(
                      context,
                      Icons.flag_outlined,
                      "Nationality",
                      profileController.nationalityCtrl,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 4. Academic Details
                _buildSectionTitle(context, "Academic Details"),
                _buildSectionContainer(
                  isDark,
                  surfaceColor,
                  children: [
                    _buildRow(
                      context,
                      Icons.percent,
                      "10th Percentage",
                      profileController.tenthCtrl,
                      suffix: "%",
                    ),
                    _buildDivider(isDark),
                    _buildRow(
                      context,
                      Icons.percent,
                      "12th Percentage",
                      profileController.twelthCtrl,
                      suffix: "%",
                    ),
                    _buildDivider(isDark),
                    _buildRow(
                      context,
                      Icons.science_outlined,
                      "12th PCB",
                      profileController.pcbCtrl,
                      suffix: "%",
                    ),
                  ],
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ================= NEW SUMMARY BOXES =================
  Widget _buildPerformanceSummary(
    BuildContext context,
    bool isDark,
    Color surfaceColor,
    dynamic profile,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            context,
            isDark,
            surfaceColor,
            "NEET Score",
            profile.neetScore?.toString() ?? "-",
            Icons.bar_chart_rounded,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSummaryCard(
            context,
            isDark,
            surfaceColor,
            "All India Rank",
            profile.allIndiaRank != null ? "#${profile.allIndiaRank}" : "-",
            Icons.emoji_events_rounded,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    bool isDark,
    Color surfaceColor,
    String label,
    String value,
    IconData icon,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
      // decoration: BoxDecoration(
      //   color: surfaceColor,
      //   borderRadius: BorderRadius.circular(20),
      //   border: Border.all(color: accentColor.withOpacity(0.15)),
      //   boxShadow: isDark
      //       ? null
      //       : [
      //           BoxShadow(
      //             color: accentColor.withOpacity(0.08),
      //             blurRadius: 18,
      //             offset: const Offset(0, 8),
      //           ),
      //         ],
      // ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 18),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ================= APP BAR ACTION =================
  Widget _buildActionButton(BuildContext context, Color primaryColor) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(right: 16),
        child: profileController.isLoading.value
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryColor,
                ),
              )
            : TextButton(
                onPressed: () {
                  if (profileController.isEditMode.value) {
                    profileController.saveProfile();
                  } else {
                    profileController.enableEdit();
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: profileController.isEditMode.value
                      ? primaryColor
                      : Colors.transparent,
                  foregroundColor: profileController.isEditMode.value
                      ? Colors.white
                      : primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  profileController.isEditMode.value ? "Save" : "Edit",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    Color surfaceColor,
    Color primaryColor,
  ) {
    return Obx(() {
      final isEditing = profileController.isEditMode.value;

      // 🔹 VIEW MODE (No profile image)
      if (!isEditing) {
        return Column(
          children: [
            const SizedBox(height: 10),
            Text(
              profileController.fullName.isNotEmpty
                  ? profileController.fullName
                  : "User Name",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              profileController.email,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 20),
          ],
        );
      }

      // 🔹 EDIT MODE (Show image upload section)
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1E1E1E), const Color(0xFF121212)]
                : [primaryColor.withOpacity(0.08), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: isDark
                        ? Colors.grey[800]
                        : Colors.grey[200],
                    backgroundImage: _getProfileImage(),
                    child: _shouldShowPlaceholder()
                        ? Icon(Icons.person, size: 60, color: Colors.grey[400])
                        : null,
                  ),
                ),

                /// 🔥 Upload button
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () => _showImagePickerOptions(context, isDark),
                    child: Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              profileController.fullName.isNotEmpty
                  ? profileController.fullName
                  : "User Name",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              profileController.email,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    });
  }

  // ================= SECTION LAYOUT =================
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: Theme.of(context).hintColor,
        ),
      ),
    );
  }

  Widget _buildSectionContainer(
    bool isDark,
    Color surfaceColor, {
    required List<Widget> children,
  }) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: profileController.isEditMode.value
              ? Colors.transparent
              : surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey.withOpacity(0.08),
          ),
          boxShadow: (!profileController.isEditMode.value && !isDark)
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Obx(
      () => profileController.isEditMode.value
          ? const SizedBox(height: 0)
          : Divider(
              height: 1,
              thickness: 1,
              indent: 56,
              color: isDark ? Colors.grey[800] : Colors.grey[100],
            ),
    );
  }

  // ================= TRANSFORMING DATA ROW =================
  Widget _buildRow(
    BuildContext context,
    IconData icon,
    String label,
    TextEditingController controller, {
    String? suffix,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    final borderColor = isDark ? Colors.grey[700]! : Colors.grey[400]!;
    final fillColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF9F9F9);
    final iconBgColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;

    return Obx(() {
      final isEditing = profileController.isEditMode.value;

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1.0,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: isEditing
            ? _buildEditField(
                key: ValueKey('edit_$label'),
                controller: controller,
                label: label,
                icon: icon,
                suffix: suffix,
                theme: theme,
                isDark: isDark,
                primaryColor: primaryColor,
                fillColor: fillColor,
                borderColor: borderColor,
              )
            : _buildViewRow(
                key: ValueKey('view_$label'),
                controller: controller,
                label: label,
                icon: icon,
                suffix: suffix,
                theme: theme,
                isDark: isDark,
                primaryColor: primaryColor,
                iconBgColor: iconBgColor,
              ),
      );
    });
  }

  // ================= SUB-WIDGET: EDIT MODE =================
  Widget _buildEditField({
    required Key key,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? suffix,
    required ThemeData theme,
    required bool isDark,
    required Color primaryColor,
    required Color fillColor,
    required Color borderColor,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: "Enter $label",
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[600] : Colors.grey[400],
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          suffixText: suffix,
          suffixStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          prefixIcon: Icon(
            icon,
            color: primaryColor.withOpacity(0.8),
            size: 22,
          ),
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 2),
            gapPadding: 6,
          ),
          labelStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: TextStyle(
            color: primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ================= SUB-WIDGET: VIEW MODE =================
  Widget _buildViewRow({
    required Key key,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? suffix,
    required ThemeData theme,
    required bool isDark,
    required Color primaryColor,
    required Color iconBgColor,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.text.isEmpty
                      ? "Not provided"
                      : "${controller.text}${suffix ?? ''}",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: controller.text.isEmpty
                        ? theme.hintColor.withOpacity(0.5)
                        : (isDark ? Colors.white : Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= IMAGE PICKER =================
  void _showImagePickerOptions(BuildContext context, bool isDark) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickerOption(
                  context,
                  Icons.camera_alt_rounded,
                  "Camera",
                  () {
                    Get.back();
                    _pickImage(ImageSource.camera);
                  },
                ),
                _buildPickerOption(
                  context,
                  Icons.photo_library_rounded,
                  "Gallery",
                  () {
                    Get.back();
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      profileController.setProfileImage(File(pickedFile.path));
    }
  }

  ImageProvider? _getProfileImage() {
    if (profileController.selectedProfileImage != null) {
      return FileImage(profileController.selectedProfileImage!);
    }
    if (profileController.profileImage.isNotEmpty) {
      return NetworkImage(
        "${profileController.profileImage}?v=${DateTime.now().millisecondsSinceEpoch}",
      );
    }
    return null;
  }

  bool _shouldShowPlaceholder() {
    return profileController.profileImage.isEmpty &&
        profileController.selectedProfileImage == null;
  }
}
