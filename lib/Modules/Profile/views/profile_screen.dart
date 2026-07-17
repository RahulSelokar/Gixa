import 'dart:io';
import 'package:Gixa/Modules/updateProfile/view/edit_profile_screen.dart';
import 'package:Gixa/naivgation/controller/nav_bar_controller.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.ensureLoaded();
    });
  }

  Color _surface(bool isDark) =>
      isDark ? const Color(0xFF21192F) : Colors.white;

  Color _surfaceSoft(bool isDark) =>
      isDark ? const Color(0xFF2B2040) : const Color(0xFFFFF3EA);

  Color _surfaceHighlight(bool isDark) =>
      isDark ? const Color(0xFF322546) : const Color(0xFFFFE9D9);

  Color _border(bool isDark) => isDark
      ? UColors.darkBorder.withOpacity(0.85)
      : UColors.border.withOpacity(0.85);

  Color _textPrimary(bool isDark) =>
      isDark ? const Color(0xFFF7F2FF) : const Color(0xFF1A1330);

  Color _textSecondary(bool isDark) =>
      isDark ? const Color(0xFFC6BCD8) : const Color(0xFF6D627F);

  Color _textMuted(bool isDark) =>
      isDark ? const Color(0xFF9E93B5) : const Color(0xFF9789AA);

  Color _pageBase(bool isDark) =>
      isDark ? const Color(0xFF120F1C) : const Color(0xFFFFFBF7);

  LinearGradient _pageGradient(bool isDark) => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: isDark
        ? const [Color(0xFF120F1C), Color(0xFF171222), Color(0xFF10111E)]
        : const [Color(0xFFFFFCF8), Color(0xFFFFF2E6), Color(0xFFF8F2FF)],
  );

  LinearGradient _heroGradient(bool isDark) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: isDark
        ? const [Color(0xFF241A33), Color(0xFF2A1C3C), Color(0xFF18243E)]
        : const [UColors.primary, UColors.primaryLight, UColors.primaryDark],
  );

  List<BoxShadow> _cardShadow(bool isDark) => [
    BoxShadow(
      color: isDark
          ? Colors.black.withOpacity(0.22)
          : UColors.primary.withOpacity(0.14),
      blurRadius: isDark ? 20 : 24,
      offset: const Offset(0, 12),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: _pageBase(isDark),
      appBar: _buildAppBar(context, isDark, primary),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: _pageGradient(isDark)),
        child: Obx(() {
          final profile = profileController.profile.value;

          if (profileController.isLoading.value && profile == null) {
            return Center(
              child: CircularProgressIndicator(
                color: primary,
                strokeWidth: 2.4,
              ),
            );
          }

          if (profile == null) {
            return _buildError(context, isDark, primary);
          }

          return RefreshIndicator(
            color: primary,
            backgroundColor: _surface(isDark),
            onRefresh: profileController.refreshProfile,
            child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                navController.updateScroll(notification.direction);
                return false;
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
                children: [
                  _buildHeader(context, isDark, primary),
                  const SizedBox(height: 18),
                  _buildRankCard(context, isDark, primary),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    isDark,
                    primary,
                    title: 'Personal Information',
                    subtitle: 'How we identify and contact you',
                    icon: Icons.badge_outlined,
                    rows: [
                      _rowData(
                        Icons.person_outline_rounded,
                        'First Name',
                        profileController.firstNameCtrl,
                      ),
                      _rowData(
                        Icons.account_circle_outlined,
                        'Last Name',
                        profileController.lastNameCtrl,
                      ),
                      _rowData(
                        Icons.mail_outline_rounded,
                        'Email',
                        profileController.emailCtrl,
                      ),
                      _rowData(
                        Icons.location_on_outlined,
                        'Address',
                        profileController.addressCtrl,
                      ),
                      _rowData(
                        Icons.calendar_month_rounded,
                        'Date of Birth',
                        profileController.dobCtrl,
                        onTap: () => _pickDate(context),
                      ),
                      _rowData(
                        Icons.wc_rounded,
                        'Gender',
                        profileController.genderCtrl,
                        readOnly: true,
                        onTap: () => _pickGender(context, isDark),
                      ),
                      _rowData(
                        Icons.public_rounded,
                        'Nationality',
                        profileController.nationalityCtrl,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    context,
                    isDark,
                    primary,
                    title: 'Academic Details',
                    subtitle:
                        'Scores used across guidance and prediction tools',
                    icon: Icons.school_outlined,
                    rows: [
                      _rowData(
                        Icons.looks_one_outlined,
                        '10th Percentage',
                        profileController.tenthCtrl,
                        suffix: '%',
                      ),
                      _rowData(
                        Icons.looks_two_outlined,
                        '12th Percentage',
                        profileController.twelthCtrl,
                        suffix: '%',
                      ),
                      _rowData(
                        Icons.biotech_outlined,
                        '12th PCB',
                        profileController.pcbCtrl,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    context,
                    isDark,
                    primary,
                    title: 'Counseling Details',
                    subtitle: 'Preferences that shape your recommendations',
                    icon: Icons.assignment_outlined,
                    rows: [
                      _rowData(
                        Icons.menu_book_rounded,
                        'Course',
                        profileController.courseCtrl,
                      ),
                      _rowData(
                        Icons.map_outlined,
                        'State',
                        profileController.stateCtrl,
                        readOnly: true,
                      ),
                      if (profileController.specialtyCtrl.text.isNotEmpty)
                        _rowData(
                          Icons.local_hospital_rounded,
                          'Specialty',
                          profileController.specialtyCtrl,
                          readOnly: true,
                        ),
                      _rowData(
                        Icons.category_rounded,
                        'Category',
                        profileController.categoryCtrl,
                        // editable, so do not set readOnly
                      ),
                      _rowData(
                        Icons.monitor_heart_outlined,
                        'NEET Score',
                        profileController.neetScoreCtrl,
                      ),
                      _rowData(
                        Icons.accessible_rounded,
                        'Reservation Categories',
                        profileController.disabilityCtrl,
                        readOnly: true,
                      ),

                      // _rowData(
                      //   Icons.verified_user_outlined,
                      //   'Reservation Categories',
                      //   profileController.horizontalReservationCtrl,
                      //   readOnly: true,
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isDark, Color primary) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 20,
      title: Text(
        'My Profile',
        style: GoogleFonts.robotoSlab(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: _textPrimary(isDark),
        ),
      ),
      actions: [
        Obx(
          () => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: profileController.isLoading.value
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: primary,
                    ),
                  )
                : InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Get.offNamed(AppRoutes.editProfile);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [UColors.primary, UColors.primaryLight],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Edit Profile',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, bool isDark, Color primary) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            color: _surface(isDark),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: _border(isDark)),
            boxShadow: _cardShadow(isDark),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: primary.withOpacity(isDark ? 0.22 : 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_off_outlined,
                  size: 34,
                  color: primary,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Could not load profile',
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoSlab(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary(isDark),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pull to refresh or retry to load your latest details.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: _textSecondary(isDark),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: profileController.refreshProfile,
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: Text(
                  'Retry',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, Color primary) {
    return Obx(() {
      final isEditing = profileController.isEditMode.value;

      return _ProfileHeroCard(
        isDark: isDark,
        isEditing: isEditing,
        fullName: profileController.fullName,
        email: profileController.email,
        course: profileController.courseCtrl.text,
        state: profileController.stateCtrl.text,
        gender: profileController.genderValue.value,
        imageProvider: _getProfileImage(),
        showPlaceholder: _shouldShowPlaceholder(),
        onCameraTap: isEditing
            ? () => _showImagePickerOptions(context, isDark)
            : null,
        onRemoveImage: isEditing
            ? () {
                Get.defaultDialog(
                  title: 'Remove Image',
                  middleText: 'Are you sure you want to delete profile image?',
                  textConfirm: 'Yes',
                  textCancel: 'No',
                  onConfirm: () {
                    Get.back();
                    profileController.deleteProfileImage();
                  },
                );
              }
            : null,
        heroGradient: _heroGradient(isDark),
        borderColor: _border(isDark),
        cardShadow: _cardShadow(isDark),
        textPrimary: _textPrimary(isDark),
        textSecondary: isDark
            ? Colors.white.withOpacity(0.82)
            : Colors.white.withOpacity(0.88),
      );
    });
  }

  Widget _buildRankCard(BuildContext context, bool isDark, Color primary) {
    return Obx(() {
      final isEditing = profileController.isEditMode.value;

      final isLocked = profileController.isRankLocked;

      final rankText = profileController.airCtrl.text.trim();

      return Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: _surface(isDark),

          borderRadius: BorderRadius.circular(20),

          border: Border.all(color: _border(isDark)),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.18 : 0.04),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// HEADER
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,

                  decoration: BoxDecoration(
                    color: primary.withOpacity(isDark ? 0.18 : 0.10),

                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: Icon(
                    Icons.workspace_premium_rounded,
                    color: primary,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'All India Rank',

                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,

                          color: _textPrimary(isDark),
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Text(
                      //   isLocked
                      //       ? 'Premium required to edit AIR rank'
                      //       : 'AIR rank can be edited',

                      //   style: GoogleFonts.inter(
                      //     fontSize: 12.5,
                      //     color: _textSecondary(isDark),

                      //     height: 1.4,
                      //   ),
                      // ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: isLocked
                        ? Colors.orange.withOpacity(0.10)
                        : Colors.green.withOpacity(0.10),

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Icon(
                        isLocked ? Icons.lock_rounded : Icons.check_circle,

                        size: 15,

                        color: isLocked ? Colors.orange : Colors.green,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        isLocked ? 'Locked' : 'Non-Editable',

                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,

                          color: isLocked ? Colors.orange : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// CONTENT
            if (isEditing)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1F1B2E)
                      : const Color(0xFFF7F7FA),

                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(
                    color: isLocked
                        ? Colors.orange.withOpacity(0.25)
                        : primary.withOpacity(0.20),
                  ),
                ),

                child: TextFormField(
                  controller: profileController.airCtrl,

                  readOnly: isLocked,

                  keyboardType: TextInputType.number,

                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,

                    color: _textPrimary(isDark),
                  ),

                  decoration: InputDecoration(
                    border: InputBorder.none,

                    hintText: 'Enter AIR rank',

                    hintStyle: GoogleFonts.inter(color: _textMuted(isDark)),

                    suffixIcon: isLocked
                        ? GestureDetector(
                            onTap: () {
                              Get.toNamed('/subscription');
                            },

                            child: Container(
                              margin: const EdgeInsets.all(8),

                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.12),

                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: const Icon(
                                Icons.workspace_premium_rounded,

                                color: Colors.orange,
                              ),
                            ),
                          )
                        : Icon(Icons.edit_rounded, color: primary),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1B1627)
                      : const Color(0xFFF8F9FD),

                  borderRadius: BorderRadius.circular(18),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      rankText.isEmpty ? 'Not Added' : '#$rankText',

                      style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,

                        color: _textPrimary(isDark),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      rankText.isEmpty
                          ? 'Add your AIR rank to get better predictions and counselling insights.'
                          : 'Used in predictions, counselling and cutoff analysis.',

                      style: GoogleFonts.inter(
                        fontSize: 13,
                        height: 1.5,

                        color: _textSecondary(isDark),
                      ),
                    ),
                  ],
                ),
              ),

            /// PREMIUM CTA
            if (isLocked)
              Padding(
                padding: const EdgeInsets.only(top: 16),

                child: InkWell(
                  borderRadius: BorderRadius.circular(14),

                  onTap: () {
                    Get.toNamed('/subscription');
                  },

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(isDark ? 0.14 : 0.08),

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: Row(
                      children: [
                        const Icon(
                          Icons.workspace_premium_rounded,

                          color: Colors.orange,
                          size: 20,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            'Upgrade to Premium to edit AIR rank.',

                            style: GoogleFonts.inter(
                              fontSize: 13,

                              fontWeight: FontWeight.w600,

                              color: _textPrimary(isDark),
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.arrow_forward_ios_rounded,

                          size: 14,

                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildSection(
    BuildContext context,
    bool isDark,
    Color primary, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<_RowData> rows,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: primary.withOpacity(isDark ? 0.18 : 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 20, color: primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.robotoSlab(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary(isDark),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: _textSecondary(isDark),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _surface(isDark),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _border(isDark)),
            boxShadow: _cardShadow(isDark),
          ),
          child: Obx(() {
            final isEditing = profileController.isEditMode.value;
            return Column(
              children: List.generate(rows.length, (index) {
                final row = rows[index];
                final isLast = index == rows.length - 1;
                return _buildRow(
                  context,
                  isDark,
                  primary,
                  row: row,
                  isEditing: isEditing,
                  showDivider: !isLast,
                );
              }),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRow(
    BuildContext context,
    bool isDark,
    Color primary, {
    required _RowData row,
    required bool isEditing,
    bool showDivider = true,
  }) {
    if (row.label == 'Date of Birth') {
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

    // Show placeholder for empty DOB
    if (row.label == 'Date of Birth' && row.controller.text.trim().isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isDark ? const Color(0xFF2A2238) : const Color(0xFFFFF7F2),

                isDark ? const Color(0xFF21192F) : const Color(0xFFFFFBF8),
              ],
            ),

            borderRadius: BorderRadius.circular(20),

            border: Border.all(color: primary.withOpacity(0.12)),
          ),

          child: Row(
            children: [
              /// ICON
              Container(
                width: 46,
                height: 46,

                decoration: BoxDecoration(
                  color: primary.withOpacity(isDark ? 0.22 : 0.10),

                  borderRadius: BorderRadius.circular(14),
                ),

                child: Icon(row.icon, color: primary, size: 22),
              ),

              const SizedBox(width: 14),

              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Date of Birth',

                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,

                        color: _textMuted(isDark),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Not Added Yet',

                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,

                        color: _textSecondary(isDark),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      'Add your DOB for better profile accuracy',

                      style: GoogleFonts.inter(
                        fontSize: 12,

                        height: 1.4,

                        color: _textMuted(isDark),
                      ),
                    ),
                  ],
                ),
              ),

              /// EDIT ICON
              if (isEditing)
                Container(
                  width: 38,
                  height: 38,

                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.10),

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Icon(
                    Icons.edit_calendar_rounded,
                    color: primary,
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1,
          child: child,
        ),
      ),
      child: isEditing
          ? _EditField(
              key: ValueKey('edit_${row.label}'),
              controller: row.controller,
              label: row.label,
              icon: row.icon,
              suffix: row.suffix,
              isDark: isDark,
              primary: primary,
              onTap: row.onTap,
              readOnly: row.readOnly || row.onTap != null,
              textPrimary: _textPrimary(isDark),
              textSecondary: _textSecondary(isDark),
              textMuted: _textMuted(isDark),
              fillColor: _surfaceSoft(isDark),
              borderColor: _border(isDark),
            )
          : _ViewRow(
              key: ValueKey('view_${row.label}'),
              controller: row.controller,
              label: row.label,
              icon: row.icon,
              suffix: row.suffix,
              isDark: isDark,
              primary: primary,
              showDivider: showDivider,
              textPrimary: _textPrimary(isDark),
              textSecondary: _textSecondary(isDark),
              textMuted: _textMuted(isDark),
            ),
    );
  }

  _RowData _rowData(
    IconData icon,
    String label,
    TextEditingController ctrl, {
    String? suffix,
    VoidCallback? onTap,
    bool readOnly = false,
  }) => _RowData(
    icon: icon,
    label: label,
    controller: ctrl,
    suffix: suffix,
    onTap: onTap,
    readOnly: readOnly,
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
    return DateFormat('dd-MM-yyyy').format(parsed);
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
      profileController.dobCtrl.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  void _pickGender(BuildContext context, bool isDark) {
    final primary = Theme.of(context).colorScheme.primary;
    final options = const [
      {'label': 'Male', 'value': 'M', 'icon': Icons.male_rounded},
      {'label': 'Female', 'value': 'F', 'icon': Icons.female_rounded},
      {'label': 'Other', 'value': 'Other', 'icon': Icons.transgender_rounded},
    ];

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 26),
        decoration: BoxDecoration(
          color: _surface(isDark),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 44,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: isDark ? Colors.white12 : Colors.black12,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Gender',
                style: GoogleFonts.robotoSlab(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary(isDark),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose the value that should appear on your profile.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: _textSecondary(isDark),
                ),
              ),
            ),
            const SizedBox(height: 14),
            ...options.map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    profileController.setGender(option['value']! as String);
                    Get.back();
                  },
                  child: Ink(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _surfaceSoft(isDark),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: _border(isDark)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: primary.withOpacity(isDark ? 0.18 : 0.10),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            option['icon']! as IconData,
                            color: primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            option['label']! as String,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _textPrimary(isDark),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: _textMuted(isDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showImagePickerOptions(BuildContext context, bool isDark) {
    Get.bottomSheet(
      _ImagePickerSheet(
        isDark: isDark,
        primary: Theme.of(context).colorScheme.primary,
        surface: _surface(isDark),
        surfaceSoft: _surfaceSoft(isDark),
        textPrimary: _textPrimary(isDark),
        textSecondary: _textSecondary(isDark),
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
    final XFile? file = await _picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1280,
      maxHeight: 1280,
    );

    if (file != null) {
      profileController.setProfileImage(File(file.path));
    }
  }

  ImageProvider? _getProfileImage() {
    if (profileController.selectedProfileImage != null) {
      return FileImage(profileController.selectedProfileImage!);
    }

    if (profileController.profileImage.isNotEmpty) {
      final imageUrl = profileController.profileImage;
      final separator = imageUrl.contains('?') ? '&' : '?';
      return NetworkImage(
        '$imageUrl${separator}v=${DateTime.now().millisecondsSinceEpoch}',
      );
    }

    return null;
  }

  bool _shouldShowPlaceholder() =>
      profileController.profileImage.isEmpty &&
      profileController.selectedProfileImage == null;
}

class _RowData {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String? suffix;
  final VoidCallback? onTap;
  final bool readOnly;

  const _RowData({
    required this.icon,
    required this.label,
    required this.controller,
    this.suffix,
    this.onTap,
    this.readOnly = false,
  });
}

class _EditSaveButton extends StatelessWidget {
  final bool isEditing;
  final bool isDark;
  final VoidCallback onTap;

  const _EditSaveButton({
    required this.isEditing,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isEditing
              ? const LinearGradient(
                  colors: [UColors.primary, UColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isEditing
              ? null
              : (isDark
                    ? Colors.white.withOpacity(0.07)
                    : Colors.white.withOpacity(0.82)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEditing
                ? Colors.transparent
                : (isDark
                      ? Colors.white.withOpacity(0.10)
                      : UColors.border.withOpacity(0.70)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isEditing ? Icons.check_rounded : Icons.edit_outlined,
              color: isEditing ? Colors.white : UColors.primary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              isEditing ? 'Save' : 'Edit',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isEditing ? Colors.white : UColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  final bool isDark;
  final bool isEditing;
  final String fullName;
  final String email;
  final String course;
  final String state;
  final String gender;
  final ImageProvider? imageProvider;
  final bool showPlaceholder;
  final VoidCallback? onCameraTap;
  final VoidCallback? onRemoveImage;
  final LinearGradient heroGradient;
  final Color borderColor;
  final List<BoxShadow> cardShadow;
  final Color textPrimary;
  final Color textSecondary;

  const _ProfileHeroCard({
    required this.isDark,
    required this.isEditing,
    required this.fullName,
    required this.email,
    required this.course,
    required this.state,
    required this.gender,
    required this.imageProvider,
    required this.showPlaceholder,
    required this.onCameraTap,
    required this.onRemoveImage,
    required this.heroGradient,
    required this.borderColor,
    required this.cardShadow,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final defaultAvatar = AssetImage(
      gender == 'F'
          ? 'assets/images/female_avtar.png'
          : 'assets/images/male_avtar.png',
    );
    final hasImage = !showPlaceholder && imageProvider != null;
    final displayName = fullName.trim().isEmpty ? 'Student Profile' : fullName;
    final displayEmail = email.trim().isEmpty
        ? 'Add your email address'
        : email;

    return Container(
      decoration: BoxDecoration(
        gradient: heroGradient,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark ? borderColor : Colors.white.withOpacity(0.18),
        ),
        boxShadow: cardShadow,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -24,
            bottom: -40,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.28),
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: SizedBox(
                              width: 88,
                              height: 88,
                              child: hasImage
                                  ? Image(
                                      image: imageProvider!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) {
                                        return Image(
                                          image: defaultAvatar,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image(
                                      image: defaultAvatar,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        if (isEditing && onCameraTap != null)
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: GestureDetector(
                              onTap: onCameraTap,
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.12),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 18,
                                  color: UColors.primary,
                                ),
                              ),
                            ),
                          ),
                        if (isEditing && hasImage && onRemoveImage != null)
                          Positioned(
                            top: -2,
                            right: -2,
                            child: GestureDetector(
                              onTap: onRemoveImage,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.55),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.delete_outline_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StatusChip(
                            label: isEditing
                                ? 'Editing Mode'
                                : 'Student Profile',
                            icon: isEditing
                                ? Icons.auto_fix_high_rounded
                                : Icons.verified_user_outlined,
                            color: Colors.white,
                            isDark: true,
                            filledOnDark: true,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            displayName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.robotoSlab(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            displayEmail,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  isEditing
                      ? 'Refresh your details so predictions, counseling, and cutoffs stay accurate.'
                      : 'Your academic profile powers smarter recommendations across the app.',
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    height: 1.45,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _HeroInfoChip(
                      label: 'Course',
                      value: course.trim().isEmpty ? 'Not added' : course,
                    ),
                    _HeroInfoChip(
                      label: 'State',
                      value: state.trim().isEmpty ? 'Not added' : state,
                    ),
                    _HeroInfoChip(label: 'Gender', value: _genderLabel(gender)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _genderLabel(String value) {
    if (value == 'M') return 'Male';
    if (value == 'F') return 'Female';
    return value.trim().isEmpty ? 'Not added' : value;
  }
}

class _HeroInfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _HeroInfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.78),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isDark;
  final bool filledOnDark;

  const _StatusChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.isDark,
    this.filledOnDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final background = filledOnDark
        ? Colors.white.withOpacity(0.14)
        : color.withOpacity(isDark ? 0.20 : 0.10);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: filledOnDark
              ? Colors.white.withOpacity(0.18)
              : color.withOpacity(isDark ? 0.30 : 0.16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewRow extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? suffix;
  final bool isDark;
  final Color primary;
  final bool showDivider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  const _ViewRow({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.isDark,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    this.suffix,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final value = controller.text.trim();
    final isEmpty = value.isEmpty;
    final displayValue = isEmpty ? 'Not provided yet' : '$value${suffix ?? ''}';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primary.withOpacity(isDark ? 0.18 : 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayValue,
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: isEmpty ? textSecondary : textPrimary,
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
            thickness: 0.8,
            indent: 74,
            endIndent: 16,
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : const Color(0xFFFFE7D4),
          ),
      ],
    );
  }
}

class _EditField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? suffix;
  final bool isDark;
  final Color primary;
  final VoidCallback? onTap;
  final bool readOnly;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color fillColor;
  final Color borderColor;

  const _EditField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.isDark,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.fillColor,
    required this.borderColor,
    this.suffix,
    this.onTap,
    this.readOnly = false,
  });

  @override
  State<_EditField> createState() => _EditFieldState();
}

class _EditFieldState extends State<_EditField> {
  late final FocusNode _focus;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();

    _focus = FocusNode();

    _focus.addListener(() {
      if (mounted) {
        setState(() {
          _hasFocus = _focus.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  TextInputType _keyboardType() {
    final lower = widget.label.toLowerCase();

    if (lower.contains('score') || lower.contains('percentage')) {
      return const TextInputType.numberWithOptions(decimal: true);
    }

    if (lower.contains('email')) {
      return TextInputType.emailAddress;
    }

    if (lower.contains('rank') || lower.contains('air')) {
      return TextInputType.number;
    }

    return TextInputType.text;
  }

  List<TextInputFormatter>? _formatters() {
    if (widget.label == 'NEET Score') {
      return [
        FilteringTextInputFormatter.digitsOnly,
        _NeetScoreInputFormatter(),
      ];
    }

    return null;
  }

  bool get _isLocked => widget.readOnly && widget.onTap == null;

  bool get _isDropdown => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final active = _hasFocus && !widget.readOnly;

    final borderColor = active
        ? widget.primary
        : _isLocked
        ? widget.borderColor.withOpacity(0.5)
        : widget.borderColor;

    final fillColor = _isLocked
        ? widget.fillColor.withOpacity(0.55)
        : widget.fillColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              fillColor,
              widget.isDark ? const Color(0xFF2A2238) : const Color(0xFFFFFBF8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: active ? 1.6 : 1.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(widget.isDark ? 0.18 : 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),

            if (active)
              BoxShadow(
                color: widget.primary.withOpacity(0.18),
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AbsorbPointer(
            absorbing: widget.readOnly,
            child: TextFormField(
              controller: widget.controller,
              focusNode: widget.readOnly ? null : _focus,
              readOnly: widget.readOnly,
              keyboardType: _keyboardType(),
              inputFormatters: _formatters(),

              autofillHints: widget.label.toLowerCase().contains('email')
                  ? [AutofillHints.email]
                  : null,

              style: GoogleFonts.inter(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: _isLocked ? widget.textMuted : widget.textPrimary,
                height: 1.4,
              ),

              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(0, 18, 18, 18),

                border: InputBorder.none,

                labelText: widget.label,

                labelStyle: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: active ? widget.primary : widget.textMuted,
                ),

                floatingLabelBehavior: FloatingLabelBehavior.always,

                hintText: _isLocked
                    ? 'Cannot be changed here'
                    : _isDropdown
                    ? 'Tap to select'
                    : 'Enter ${widget.label.toLowerCase()}',

                hintStyle: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: widget.textMuted.withOpacity(0.6),
                ),

                suffixText: widget.suffix,

                suffixStyle: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: widget.textMuted,
                ),

                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 12, 8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: active
                          ? widget.primary.withOpacity(
                              widget.isDark ? 0.24 : 0.12,
                            )
                          : widget.primary.withOpacity(
                              widget.isDark ? 0.15 : 0.08,
                            ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      widget.icon,
                      color: active
                          ? widget.primary
                          : widget.primary.withOpacity(0.72),
                      size: 20,
                    ),
                  ),
                ),

                prefixIconConstraints: const BoxConstraints(
                  minWidth: 68,
                  minHeight: 58,
                ),

                suffixIcon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      _isLocked
                          ? Icons.lock_outline_rounded
                          : _isDropdown
                          ? Icons.keyboard_arrow_down_rounded
                          : active
                          ? Icons.edit_rounded
                          : Icons.check_circle_outline_rounded,
                      key: ValueKey(active),
                      size: 18,
                      color: _isLocked
                          ? widget.textMuted.withOpacity(0.55)
                          : _isDropdown
                          ? widget.textMuted
                          : widget.primary.withOpacity(0.78),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NeetScoreInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.trim();
    if (text.isEmpty) {
      return newValue;
    }

    final score = int.tryParse(text);
    if (score == null || score > 720) {
      return oldValue;
    }

    return newValue;
  }
}

class _ImagePickerSheet extends StatelessWidget {
  final bool isDark;
  final Color primary;
  final Color surface;
  final Color surfaceSoft;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  const _ImagePickerSheet({
    required this.isDark,
    required this.primary,
    required this.surface,
    required this.surfaceSoft,
    required this.textPrimary,
    required this.textSecondary,
    required this.onCamera,
    required this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 34),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 44,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: isDark ? Colors.white12 : Colors.black12,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          Text(
            'Update Photo',
            style: GoogleFonts.robotoSlab(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose how you want to update your profile picture.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 13, color: textSecondary),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: _PickerOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  subtitle: 'Take a new photo',
                  primary: primary,
                  surfaceSoft: surfaceSoft,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onTap: onCamera,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PickerOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  subtitle: 'Pick from photos',
                  primary: primary,
                  surfaceSoft: surfaceSoft,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onTap: onGallery,
                ),
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
  final String subtitle;
  final Color primary;
  final Color surfaceSoft;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  const _PickerOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.primary,
    required this.surfaceSoft,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        decoration: BoxDecoration(
          color: surfaceSoft,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: primary, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
