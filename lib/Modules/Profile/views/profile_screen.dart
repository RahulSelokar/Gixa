import 'dart:io';
import 'package:Gixa/naivgation/controller/nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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

  // ─── Theme helpers ───────────────────────────────────────────────────────
  Color _bg(bool isDark) =>
      isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F5F7);

  Color _surface(bool isDark) =>
      isDark ? const Color(0xFF1C1C1E) : Colors.white;

  Color _border(bool isDark) =>
      isDark ? Colors.white.withOpacity(0.07) : Colors.black.withOpacity(0.06);

  Color _label(bool isDark) =>
      isDark ? Colors.white38 : const Color(0xFF8E8E93);

  Color _text(bool isDark) => isDark ? Colors.white : const Color(0xFF111111);

  // ─── Build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: _bg(isDark),
      appBar: _buildAppBar(context, isDark, primary),
      body: Obx(() {
        final profile = profileController.profile.value;

        if (profileController.isLoading.value && profile == null) {
          return Center(
            child: CircularProgressIndicator(color: primary, strokeWidth: 2),
          );
        }

        if (profile == null) {
          return _buildError(context, primary);
        }

        return RefreshIndicator(
          onRefresh: profileController.refreshProfile,
          color: primary,
          child: NotificationListener<UserScrollNotification>(
            onNotification: (n) {
              navController.updateScroll(n.direction);
              return false;
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildHeader(context, isDark, primary),
                const SizedBox(height: 16),
                _buildRankCard(context, isDark, profile, primary),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  isDark,
                  primary,
                  title: "Personal Information",
                  icon: Icons.person_outline_rounded,
                  rows: [
                    _rowData(
                      "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Identification%20card/3D/identification_card_3d.png",
                      "First Name",
                      profileController.firstNameCtrl,
                    ),
                    _rowData(
                      "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Name%20badge/3D/name_badge_3d.png",
                      "Last Name",
                      profileController.lastNameCtrl,
                    ),
                    _rowData(
                      "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Round%20pushpin/3D/round_pushpin_3d.png",
                      "Address",
                      profileController.addressCtrl,
                    ),
                    _rowData(
                      "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Calendar/3D/calendar_3d.png",
                      "Date of Birth",
                      profileController.dobCtrl,
                      onTap: () => _pickDate(context),
                    ),
                    _rowData(
                      "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Globe%20with%20meridians/3D/globe_with_meridians_3d.png",
                      "Nationality",
                      profileController.nationalityCtrl,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSection(
                  context,
                  isDark,
                  primary,
                  title: "Academic Details",
                  icon: Icons.school_outlined,
                  rows: [
                    _rowData(
                      "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Hundred%20points/3D/hundred_points_3d.png",
                      "10th Percentage",
                      profileController.tenthCtrl,
                      suffix: "%",
                    ),
                    _rowData(
                      "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Graduation%20cap/3D/graduation_cap_3d.png",
                      "12th Percentage",
                      profileController.twelthCtrl,
                      suffix: "%",
                    ),
                    _rowData(
                      "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Microscope/3D/microscope_3d.png",
                      "12th PCB",
                      profileController.pcbCtrl,
                      suffix: "%",
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSection(
                  context,
                  isDark,
                  primary,
                  title: "Counseling Details",
                  icon: Icons.assignment_outlined,
                  rows: [
                    _rowData(
                      "assets/images/applications.png",
                      "Course",
                      profileController.courseCtrl,
                    ),
                    _rowData(
                      "assets/images/applications.png",
                      "Category",
                      profileController.categoryCtrl,
                    ),
                    _rowData(
                      "assets/images/applications.png",
                      "State",
                      profileController.stateCtrl,
                    ),
                    _rowData(
                      "assets/images/applications.png",
                      "Caste",
                      profileController.casteCtrl,
                    ),
                    _rowData(
                      "assets/images/applications.png",
                      "NEET Score",
                      profileController.neetScoreCtrl,
                    ),
                  ],
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ─── AppBar ──────────────────────────────────────────────────────────────
  AppBar _buildAppBar(BuildContext context, bool isDark, Color primary) {
    return AppBar(
      backgroundColor: _bg(isDark),
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        "My Profile",
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: _text(isDark),
        ),
      ),
      centerTitle: false,
      actions: [
        Obx(
          () => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: profileController.isLoading.value
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primary,
                    ),
                  )
                : _EditSaveButton(
                    isEditing: profileController.isEditMode.value,
                    primary: primary,
                    isDark: isDark,
                    onTap: () {
                      if (profileController.isEditMode.value) {
                        profileController.saveProfile();
                      } else {
                        profileController.enableEdit();
                      }
                    },
                  ),
          ),
        ),
      ],
    );
  }

  // ─── Error state ─────────────────────────────────────────────────────────
  Widget _buildError(BuildContext context, Color primary) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 52,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "Could not load profile",
            style: GoogleFonts.inter(fontSize: 15, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: profileController.refreshProfile,
            style: FilledButton.styleFrom(backgroundColor: primary),
            child: Text(
              "Retry",
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, bool isDark, Color primary) {
    return Obx(() {
      final isEditing = profileController.isEditMode.value;

      if (!isEditing) {
        return _ViewHeader(
          isDark: isDark,
          primary: primary,
          fullName: profileController.fullName,
          email: profileController.email,
          imageProvider: _getProfileImage(),
          showPlaceholder: _shouldShowPlaceholder(),
        );
      }

      return _EditHeader(
        isDark: isDark,
        primary: primary,
        fullName: profileController.fullName,
        email: profileController.email,
        imageProvider: _getProfileImage(),
        showPlaceholder: _shouldShowPlaceholder(),
        onCameraTap: () => _showImagePickerOptions(context, isDark),
      );
    });
  }

  // ─── Rank card ───────────────────────────────────────────────────────────
  Widget _buildRankCard(
    BuildContext context,
    bool isDark,
    dynamic profile,
    Color primary,
  ) {
    final rank = profile.allIndiaRank != null
        ? "#${profile.allIndiaRank}"
        : "—";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: _surface(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border(isDark)),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.network(
              "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Trophy/3D/trophy_3d.png",
              height: 30,
              width: 30,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.emoji_events_outlined, color: primary, size: 26),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "All India Rank",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: _label(isDark),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  rank,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _text(isDark),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "AIR",
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section builder ─────────────────────────────────────────────────────
  Widget _buildSection(
    BuildContext context,
    bool isDark,
    Color primary, {
    required String title,
    required IconData icon,
    required List<_RowData> rows,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Icon(icon, size: 16, color: _label(isDark)),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: _label(isDark),
                ),
              ),
            ],
          ),
        ),

        // Cards
        Obx(() {
          final isEditing = profileController.isEditMode.value;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: isEditing
                ? const BoxDecoration()
                : BoxDecoration(
                    color: _surface(isDark),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _border(isDark)),
                    boxShadow: isDark
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
            child: Column(
              children: List.generate(rows.length, (i) {
                final row = rows[i];
                final isLast = i == rows.length - 1;
                return _buildRow(
                  context,
                  isDark,
                  primary,
                  row: row,
                  showDivider: !isLast,
                );
              }),
            ),
          );
        }),
      ],
    );
  }

  // ─── Row builder ─────────────────────────────────────────────────────────
  Widget _buildRow(
    BuildContext context,
    bool isDark,
    Color primary, {
    required _RowData row,
    bool showDivider = true,
  }) {
    return Obx(() {
      final isEditing = profileController.isEditMode.value;

      if (isEditing && row.label == "Date of Birth") {
        final current = row.controller.text.trim();
        if (current.isNotEmpty) {
          final formatted = _formatDobForDisplay(current);
          if (formatted != current) {
            row.controller.value = TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(offset: formatted.length),
            );
          }
        }
      }

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) => SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1,
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: isEditing
            ? _EditField(
                key: ValueKey('edit_${row.label}'),
                controller: row.controller,
                label: row.label,
                iconPath: row.iconPath,
                suffix: row.suffix,
                isDark: isDark,
                primary: primary,
                onTap: row.onTap,
                readOnly: row.onTap != null,
              )
            : _ViewRow(
                key: ValueKey('view_${row.label}'),
                controller: row.controller,
                label: row.label,
                iconPath: row.iconPath,
                suffix: row.suffix,
                isDark: isDark,
                primary: primary,
                showDivider: showDivider,
              ),
      );
    });
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────
  _RowData _rowData(
    String icon,
    String label,
    TextEditingController ctrl, {
    String? suffix,
    VoidCallback? onTap,
  }) => _RowData(
    iconPath: icon,
    label: label,
    controller: ctrl,
    suffix: suffix,
    onTap: onTap,
  );

  DateTime? _parseDob(String raw) {
    if (raw.isEmpty) return null;

    final iso = DateTime.tryParse(raw);
    if (iso != null) return iso;

    final parts = raw.split(RegExp(r'[-/]'));
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) return null;

    return DateTime.tryParse(
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}',
    );
  }

  String _formatDobForDisplay(String raw) {
    final parsed = _parseDob(raw.trim());
    if (parsed == null) return raw;
    return DateFormat('dd/MM/yyyy').format(parsed);
  }

  Future<void> _pickDate(BuildContext context) async {
    final currentText = profileController.dobCtrl.text.trim();
    final parsedCurrent = _parseDob(currentText);
    final initialDate = parsedCurrent ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      profileController.dobCtrl.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void _showImagePickerOptions(BuildContext context, bool isDark) {
    Get.bottomSheet(
      _ImagePickerSheet(
        isDark: isDark,
        onCamera: () {
          Get.back();
          _pickImage(ImageSource.camera);
        },
        onGallery: () {
          Get.back();
          _pickImage(ImageSource.gallery);
        },
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? file = await _picker.pickImage(source: source);
    if (file != null) {
      profileController.setProfileImage(File(file.path));
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

  bool _shouldShowPlaceholder() =>
      profileController.profileImage.isEmpty &&
      profileController.selectedProfileImage == null;
}

// ─────────────────────────────────────────────
//  DATA HOLDER
// ─────────────────────────────────────────────
class _RowData {
  final String iconPath;
  final String label;
  final TextEditingController controller;
  final String? suffix;
  final VoidCallback? onTap;

  _RowData({
    required this.iconPath,
    required this.label,
    required this.controller,
    this.suffix,
    this.onTap,
  });
}

// ─────────────────────────────────────────────
//  EDIT / SAVE BUTTON
// ─────────────────────────────────────────────
class _EditSaveButton extends StatelessWidget {
  final bool isEditing;
  final Color primary;
  final bool isDark;
  final VoidCallback onTap;

  const _EditSaveButton({
    required this.isEditing,
    required this.primary,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isEditing ? primary : primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          isEditing ? "Save" : "Edit",
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isEditing ? Colors.white : primary,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  VIEW HEADER
// ─────────────────────────────────────────────
class _ViewHeader extends StatelessWidget {
  final bool isDark;
  final Color primary;
  final String fullName;
  final String email;
  final ImageProvider? imageProvider;
  final bool showPlaceholder;

  const _ViewHeader({
    required this.isDark,
    required this.primary,
    required this.fullName,
    required this.email,
    required this.imageProvider,
    required this.showPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        // Avatar
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: primary.withOpacity(0.25), width: 2.5),
          ),
          child: ClipOval(
            child: showPlaceholder || imageProvider == null
                ? Container(
                    color: primary.withOpacity(0.1),
                    child: Icon(
                      Icons.person_rounded,
                      size: 44,
                      color: primary.withOpacity(0.5),
                    ),
                  )
                : Image(image: imageProvider!, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          fullName.isNotEmpty ? fullName : "User Name",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF111111),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          email,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isDark ? Colors.white38 : const Color(0xFF8E8E93),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  EDIT HEADER
// ─────────────────────────────────────────────
class _EditHeader extends StatelessWidget {
  final bool isDark;
  final Color primary;
  final String fullName;
  final String email;
  final ImageProvider? imageProvider;
  final bool showPlaceholder;
  final VoidCallback onCameraTap;

  const _EditHeader({
    required this.isDark,
    required this.primary,
    required this.fullName,
    required this.email,
    required this.imageProvider,
    required this.showPlaceholder,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.07)
              : Colors.black.withOpacity(0.06),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primary.withOpacity(0.2), width: 3),
                ),
                child: ClipOval(
                  child: SizedBox(
                    width: 96,
                    height: 96,
                    child: showPlaceholder || imageProvider == null
                        ? Container(
                            color: primary.withOpacity(0.08),
                            child: Icon(
                              Icons.person_rounded,
                              size: 50,
                              color: primary.withOpacity(0.5),
                            ),
                          )
                        : Image(image: imageProvider!, fit: BoxFit.cover),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: GestureDetector(
                  onTap: onCameraTap,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            fullName.isNotEmpty ? fullName : "User Name",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            email,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? Colors.white38 : const Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  VIEW ROW
// ─────────────────────────────────────────────
class _ViewRow extends StatelessWidget {
  final Key key;
  final TextEditingController controller;
  final String label;
  final String iconPath;
  final String? suffix;
  final bool isDark;
  final Color primary;
  final bool showDivider;

  const _ViewRow({
    required this.key,
    required this.controller,
    required this.label,
    required this.iconPath,
    required this.isDark,
    required this.primary,
    this.suffix,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final empty = controller.text.isEmpty;
    final value = empty ? "Not provided" : "${controller.text}${suffix ?? ''}";

    return Column(
      key: key,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(9),
                  child: _buildIcon(iconPath, primary),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white38
                            : const Color(0xFF8E8E93),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: empty
                            ? (isDark ? Colors.white24 : Colors.black26)
                            : (isDark ? Colors.white : const Color(0xFF111111)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 70,
            endIndent: 0,
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.black.withOpacity(0.06),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  EDIT FIELD
// ─────────────────────────────────────────────
class _EditField extends StatelessWidget {
  final Key key;
  final TextEditingController controller;
  final String label;
  final String iconPath;
  final String? suffix;
  final bool isDark;
  final Color primary;
  final VoidCallback? onTap;
  final bool readOnly;

  const _EditField({
    required this.key,
    required this.controller,
    required this.label,
    required this.iconPath,
    required this.isDark,
    required this.primary,
    this.suffix,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : const Color(0xFF111111),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(
            fontSize: 13,
            color: isDark ? Colors.white38 : const Color(0xFF8E8E93),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: "Enter $label",
          hintStyle: GoogleFonts.inter(
            fontSize: 13,
            color: isDark ? Colors.white24 : Colors.black26,
          ),
          suffixText: suffix,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(13),
            child: _buildIcon(iconPath, primary),
          ),
          filled: true,
          fillColor: isDark
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFFF9F9F9),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  IMAGE PICKER SHEET
// ─────────────────────────────────────────────
class _ImagePickerSheet extends StatelessWidget {
  final bool isDark;
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  const _ImagePickerSheet({
    required this.isDark,
    required this.onCamera,
    required this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 36,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: isDark ? Colors.white12 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            "Update Photo",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _PickerOption(
                icon: Icons.camera_alt_rounded,
                label: "Camera",
                primary: primary,
                isDark: isDark,
                onTap: onCamera,
              ),
              _PickerOption(
                icon: Icons.photo_library_rounded,
                label: "Gallery",
                primary: primary,
                isDark: isDark,
                onTap: onGallery,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color primary;
  final bool isDark;
  final VoidCallback onTap;

  const _PickerOption({
    required this.icon,
    required this.label,
    required this.primary,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: primary, size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SHARED ICON HELPER
// ─────────────────────────────────────────────
Widget _buildIcon(String path, Color color) {
  if (path.startsWith("http")) {
    return Image.network(
      path,
      height: 22,
      width: 22,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.info_outline, color: color, size: 20),
    );
  }
  return Image.asset(path, height: 22, width: 22, color: color);
}
