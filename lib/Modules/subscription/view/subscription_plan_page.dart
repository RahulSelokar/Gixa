import 'package:Gixa/Modules/Auth/model/Auth/user_model.dart';
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/subscription/controller/subsciption_history_controller.dart';
import 'package:Gixa/Modules/subscription/model/subscription_purchase_model.dart';
import 'package:Gixa/Modules/subscription/view/subscription_history_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/subscription_controller.dart';
import '../model/subscription_plan.dart';

class SubscriptionPage extends StatefulWidget {
  SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final controller = Get.find<SubscriptionController>();
  final historyController = Get.find<SubscriptionHistoryController>();

  @override
  void initState() {
    super.initState();
    // Always refresh plans when page is opened
    controller.fetchPlans();
    
  }

  int _parseAmount(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.parse(cleaned).round();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Plans'),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () {
              Get.to(() => const SubscriptionHistoryPage());
            },
            icon: Icon(
              Icons.history,
              size: 20,
              color: isDark ? Colors.white : Colors.black,
            ),
            label: Text(
              'History',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),

      body: Obx(() {
        print("===== SUBSCRIPTION PAGE DEBUG =====");
        print("Is Subscribed: ${controller.isSubscribed}");
        print("Active Plan: ${controller.activePlan.value?.planName}");
        print("Plans Count: ${controller.plans.length}");
        print("===================================");

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.plans.length,
          itemBuilder: (_, i) {
            final plan = controller.plans[i];
            final preview = controller.previewFor(plan.id);
            final couponController = TextEditingController();
            final amount = _parseAmount(plan.amount);
            final payable = preview != null
                ? _parseAmount(preview.finalPayableAmount)
                : amount;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: plan.isRecommended
                      ? Colors.orange
                      : Colors.grey.withOpacity(0.2),
                  width: plan.isRecommended ? 2 : 1,
                ),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔥 PLAN HEADER
                  Row(
                    children: [
                      Text(
                        plan.planName,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (plan.isRecommended)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'BEST VALUE',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '₹$amount / ${plan.durationDays} days',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// ⭐ FEATURES
                  ...plan.features.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              f.featureTitle,
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 28),

                  /// 🎟 COUPON
                  Obx(() {
                    final isPurchased = historyController.isPlanActive(plan.id);

                    return TextField(
                      controller: couponController,
                      enabled: !isPurchased, // 🔥 Disable entire field
                      decoration: InputDecoration(
                        hintText: 'Enter coupon code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: TextButton(
                          onPressed: isPurchased
                              ? null
                              : () {
                                  controller.applyCoupon(
                                    planId: plan.id,
                                    couponCode: couponController.text
                                        .trim()
                                        .toUpperCase(),
                                  );
                                },
                          child: Text(
                            isPurchased ? 'N/A' : 'Apply',
                            style: TextStyle(
                              color: isPurchased ? Colors.grey : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  /// ❌ COUPON ERROR
                  Obx(() {
                    final error = controller.couponErrorFor(plan.id);
                    if (error.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  /// 💰 FINAL PAYABLE
                  Text(
                    'Payable Amount: ₹$payable',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// 💳 PAY BUTTON
                  Obx(() {
                    final isPurchased = historyController.isPlanActive(plan.id);

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: isPurchased
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                        ),
                        onPressed: isPurchased
                            ? null
                            : () => _openConfirmSheet(
                                context,
                                plan,
                                preview,
                                payable,
                              ),
                        child: Text(
                          isPurchased ? 'Purchased' : 'Proceed to Payment',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  // ─────────────────────────────────────────────
  // 💳 CONFIRMATION BOTTOM SHEET
  // ─────────────────────────────────────────────
  void _openConfirmSheet(
    BuildContext context,
    SubscriptionPlan plan,
    SubscriptionPurchaseData? preview,
    int payable,
  ) {
    final profileController = Get.find<ProfileController>();
    final profile = profileController.profile.value;
    final user = profile?.user;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ── DRAG HANDLE
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// ── TITLE
              Text(
                'Confirm Purchase',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              /// ── USER INFO
              _row(
                'Name',
                user != null
                    ? '${user.firstName} ${user.lastName}'.trim()
                    : '-',
              ),
              _row('Mobile', user?.mobileNumber ?? '-'),
              _row('Plan', plan.planName),

              const Divider(height: 28),

              /// ── PRICE BREAKDOWN
              _row('Base Amount', '₹${_parseAmount(plan.amount)}'),

              if (preview != null && _parseAmount(preview.couponDiscount) > 0)
                _row(
                  'Discount',
                  '- ₹${_parseAmount(preview.couponDiscount)}',
                  color: Colors.green,
                ),

              if (preview != null && preview.extraDays > 0)
                _row(
                  'Extra Days',
                  '+ ${preview.extraDays} days',
                  color: Colors.blue,
                ),

              const Divider(height: 28),

              /// ── FINAL PAYABLE
              _row(
                'Payable Amount',
                '₹$payable',
                isBold: true,
                color: Colors.green,
              ),

              const SizedBox(height: 20),

              /// ── PAY BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    controller.createOrderAndPay(plan.id);
                  },
                  child: const Text('Pay Now', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _row(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
