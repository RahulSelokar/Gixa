import 'package:Gixa/Modules/Assistance/controller/request_guidance_controller.dart';
import 'package:Gixa/Modules/Assistance/model/request_guidance_model.dart';
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/subscription/model/subscription_plan.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';
import 'package:Gixa/services/auth_guard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestGuidanceDialog extends StatefulWidget {
  const RequestGuidanceDialog({
    super.key,
    this.counselorId,
    this.closeOnSuccess = true,
    this.onSuccess,
    this.selectedPlan,
  });

  final int? counselorId;
  final bool closeOnSuccess;
  final VoidCallback? onSuccess;
  final SubscriptionPlan? selectedPlan;

  @override
  State<RequestGuidanceDialog> createState() => _RequestGuidanceDialogState();
}

class _RequestGuidanceDialogState extends State<RequestGuidanceDialog> {
  late final RequestGuidanceController controller;

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final selectedPlanCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final messageCtrl = TextEditingController();
  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final emailFocus = FocusNode();
  final mobileFocus = FocusNode();
  final messageFocus = FocusNode();
  bool _hasValidSession = false;
  bool _isCheckingSession = true;
  final profileController = Get.find<ProfileController>();
  @override
  void initState() {
    super.initState();
    controller = Get.put(RequestGuidanceController());

    _syncSelectedPlan();
    _refreshSessionState();
    _updateMessage();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await profileController.ensureLoaded();

      firstNameCtrl.text = profileController.firstNameCtrl.text;
      lastNameCtrl.text = profileController.lastNameCtrl.text;
      emailCtrl.text = profileController.emailCtrl.text;
      mobileCtrl.text = profileController.mobilectrl.text;

      print("MOBILE NUMBER: ${profileController.mobilectrl.text}");

      if (mounted) {
        setState(() {});
      }
    });
  }

  void _updateMessage() {
    final plan = widget.selectedPlan;

    if (plan == null) return;

    messageCtrl.text =
        '''Hello Team,
I would like guidance regarding the "${plan.planName}" subscription plan.
Plan Duration: ${plan.durationDays} days
Price: ₹${plan.amount}
Please help me understand this plan better.

''';
  }

  @override
  void didUpdateWidget(covariant RequestGuidanceDialog oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedPlan?.id != widget.selectedPlan?.id) {
      _syncSelectedPlan();

      _updateMessage();

      setState(() {});
    }
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    mobileCtrl.dispose();
    selectedPlanCtrl.dispose();
    emailCtrl.dispose();
    messageCtrl.dispose();
    if (Get.isRegistered<RequestGuidanceController>()) {
      Get.delete<RequestGuidanceController>();
    }
    firstNameFocus.dispose();
    emailFocus.dispose();
    lastNameFocus.dispose();
    mobileFocus.dispose();
    messageFocus.dispose();
    super.dispose();
  }

  void _syncSelectedPlan() {
    selectedPlanCtrl.text = widget.selectedPlan?.planName ?? '';
  }

  Future<void> _refreshSessionState() async {
    final hasValidSession = await AuthGuard.hasValidSession();
    if (!mounted) return;

    setState(() {
      _hasValidSession = hasValidSession;
      _isCheckingSession = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final inputFill = isDark
        ? Colors.white.withOpacity(0.04)
        : const Color(0xFFF8FAFD);
    final helperText = widget.selectedPlan == null
        ? 'Choose a plan from the slider above to tailor this subscription help request.'
        : 'We will send your selected plan with this request so the team can guide you faster.';

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE7ECF3),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.workspace_premium_rounded,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.counselorId == null
                                ? 'Subscription Help Request'
                                : 'Plan Guidance Request',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Share your details and we will help you pick the right plan.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: colorScheme.onSurface.withOpacity(0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          helperText,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                if (!_isCheckingSession && !_hasValidSession) ...[
                  _GuestLoginNotice(
                    title: 'Login to send your request',
                    description:
                        'Sign in with OTP to submit subscription assistance requests and track counselor updates.',
                    buttonLabel: 'Login to Continue',
                    onTap: _handleSubmit,
                  ),
                  const SizedBox(height: 18),
                ],
                // _buildTextField(
                //   context,
                //   'Selected Plan',
                //   selectedPlanCtrl,
                //   fillColor: inputFill,
                //   readOnly: true,
                //   hintText: 'Select a plan from the cards above',
                //   prefixIcon: Icons.subscriptions_outlined,
                //   trailing: widget.selectedPlan != null
                //       ? _PlanTag(
                //           label: _formatDuration(
                //             widget.selectedPlan!.durationDays,
                //           ),
                //         )
                //       : null,
                // ),
                // if (widget.selectedPlan != null) ...[
                //   const SizedBox(height: 12),
                //   Container(
                //     width: double.infinity,
                //     padding: const EdgeInsets.all(14),
                //     decoration: BoxDecoration(
                //       color: isDark
                //           ? Colors.white.withOpacity(0.04)
                //           : const Color(0xFFFFF8F1),
                //       borderRadius: BorderRadius.circular(16),
                //       border: Border.all(
                //         color: colorScheme.primary.withOpacity(0.14),
                //       ),
                //     ),
                //     child: Row(
                //       children: [
                //         Container(
                //           padding: const EdgeInsets.all(10),
                //           decoration: BoxDecoration(
                //             color: colorScheme.primary.withOpacity(0.10),
                //             borderRadius: BorderRadius.circular(12),
                //           ),
                //           child: Icon(
                //             Icons.sell_rounded,
                //             color: colorScheme.primary,
                //             size: 18,
                //           ),
                //         ),
                //         const SizedBox(width: 12),
                //         Expanded(
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 widget.selectedPlan!.planName,
                //                 style: GoogleFonts.inter(
                //                   fontSize: 13.5,
                //                   fontWeight: FontWeight.w700,
                //                 ),
                //               ),
                //               const SizedBox(height: 3),
                //               Text(
                //                 '${_formatPrice(widget.selectedPlan!.amount)} • ${_formatDuration(widget.selectedPlan!.durationDays)}',
                //                 style: GoogleFonts.inter(
                //                   fontSize: 12.5,
                //                   color: colorScheme.onSurface.withOpacity(
                //                     0.68,
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ],
                // const SizedBox(height: 16),
                Column(
                  children: [
                    _buildTextField(
                      context,
                      'First Name',
                      firstNameCtrl,
                      focusNode: firstNameFocus,
                      fillColor: inputFill,
                      prefixIcon: Icons.person_outline_rounded,
                      readOnly: true,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      context,
                      'Last Name',
                      lastNameCtrl,
                      fillColor: inputFill,
                      focusNode: lastNameFocus,
                      prefixIcon: Icons.badge_outlined,
                      readOnly: true,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      context,
                      'Email',
                      emailCtrl,
                      fillColor: inputFill,
                      focusNode: emailFocus,
                      prefixIcon: Icons.email_outlined,
                      readOnly: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  context,
                  'Mobile Number',
                  mobileCtrl,
                  keyboard: TextInputType.phone,
                  focusNode: mobileFocus,
                  fillColor: inputFill,
                  prefixIcon: Icons.phone_outlined,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 240,

                  child: Scrollbar(
                    thumbVisibility: true,

                    radius: const Radius.circular(20),

                    child: TextField(
                      controller: messageCtrl,
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      scrollPhysics: const BouncingScrollPhysics(),
                      focusNode: messageFocus,
                      decoration: InputDecoration(
                        labelText: 'How can we help?',
                        hintText:
                            'Tell us whether you need help choosing, understanding, or comparing this plan.',
                        filled: true,

                        fillColor: inputFill,

                        alignLabelWithHint: true,

                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 150),

                          child: Icon(Icons.edit_note_rounded),
                        ),

                        /// 🔥 Scroll Arrow
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 10, right: 4),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).dividerColor.withOpacity(0.5),
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,

                            width: 1.4,
                          ),
                        ),

                        contentPadding: const EdgeInsets.fromLTRB(
                          18,
                          20,
                          18,
                          20,
                        ),
                      ),

                      style: GoogleFonts.inter(fontSize: 14, height: 1.7),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _hasValidSession
                                ? 'Submit Request'
                                : 'Login to Submit Request',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    await AuthGuard.checkAccess(
      onAllowed: () {
        _submitAfterAuth();
      },
    );
  }

  Future<void> _submitAfterAuth() async {
    await _refreshSessionState();
    if (!_hasValidSession) return;
    if (firstNameCtrl.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(firstNameFocus);

      AppSnackbar.show('Required', 'Please enter first name');

      return;
    }

    if (lastNameCtrl.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(lastNameFocus);

      AppSnackbar.show('Required', 'Please enter last name');

      return;
    }

    if (mobileCtrl.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(mobileFocus);

      AppSnackbar.show('Required', 'Please enter mobile number');

      return;
    }

    if (messageCtrl.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(messageFocus);

      AppSnackbar.show('Required', 'Please enter message');

      return;
    }
    if (emailCtrl.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(emailFocus);

      AppSnackbar.show('Required', 'Please enter email');

      return;
    }

    if (!GetUtils.isEmail(emailCtrl.text.trim())) {
      FocusScope.of(context).requestFocus(emailFocus);

      AppSnackbar.show('Invalid', 'Please enter valid email');

      return;
    }
    final plan = widget.selectedPlan;
    final successMessage = await controller.submit(
      RequestGuidanceRequest(
        counselorId: widget.counselorId,
        subscriptionPlanId: plan?.id,
        subscriptionPlanName: plan?.planName ?? '',
        subscriptionPlanCode: plan?.planCode ?? '',
        firstName: firstNameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
        mobileNumber: mobileCtrl.text.trim(),
        message: messageCtrl.text.trim(),
        email: emailCtrl.text.trim(),
      ),
    );

    if (!mounted || successMessage == null) return;

    widget.onSuccess?.call();

    if (widget.closeOnSuccess) {
      Get.back();
      Future.microtask(() {
        AppSnackbar.show(
          'Request Sent',
          successMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    } else {
      AppSnackbar.show(
        'Request Sent',
        successMessage,
        snackPosition: SnackPosition.BOTTOM,
      );

      messageCtrl.clear();
    }
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
    Color? fillColor,
    bool readOnly = false,
    String? hintText,
    IconData? prefixIcon,
    Widget? trailing,
    FocusNode? focusNode,
  }) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboard,
      readOnly: readOnly,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        filled: true,
        fillColor: fillColor,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        suffixIcon: trailing == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: 10),
                child: trailing,
              ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 30,
          minWidth: 30,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.4),
        ),
      ),
    );
  }

  String _formatPrice(String value) {
    final amount = value.trim();
    if (amount.isEmpty) return 'Price on request';
    return amount.startsWith('₹') ? amount : '₹$amount';
  }

  String _formatDuration(int days) {
    if (days <= 0) return 'Custom duration';
    if (days % 30 == 0) {
      final months = days ~/ 30;
      return months == 1 ? '1 month' : '$months months';
    }
    if (days % 7 == 0) {
      final weeks = days ~/ 7;
      return weeks == 1 ? '1 week' : '$weeks weeks';
    }
    return days == 1 ? '1 day' : '$days days';
  }
}

class _GuestLoginNotice extends StatelessWidget {
  const _GuestLoginNotice({
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onTap,
  });

  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              height: 1.5,
              color: theme.colorScheme.onSurface.withOpacity(0.72),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.phone_android_rounded),
              label: Text(buttonLabel),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanTag extends StatelessWidget {
  final String label;

  const _PlanTag({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.10),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
