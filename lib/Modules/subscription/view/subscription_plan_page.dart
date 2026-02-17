// import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
// import 'package:Gixa/Modules/payment/controller/payment_controller.dart';
// import 'package:Gixa/services/razorpay_services.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../controller/subscription_controller.dart';
// import '../model/subscription_plan.dart';

// class SubscriptionPage extends StatelessWidget {
//   SubscriptionPage({super.key});

//   final SubscriptionController controller = Get.put(SubscriptionController());

//   final PaymentController paymentController = Get.put(
//     PaymentController(),
//     permanent: true,
//   );

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Subscription Plans'),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.error.isNotEmpty) {
//           return Center(
//             child: Text(
//               controller.error.value,
//               style: const TextStyle(color: Colors.red),
//             ),
//           );
//         }

//         if (controller.plans.isEmpty) {
//           return const Center(child: Text('No plans available'));
//         }

//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: controller.plans.length,
//           itemBuilder: (context, index) {
//             final plan = controller.plans[index];
//             return _PlanCard(
//               plan: plan,
//               isDark: isDark,
//               controller: controller,
//             );
//           },
//         );
//       }),
//     );
//   }
// }

// /// ─────────────────────────────────────────────
// /// 🧾 PLAN CARD (PER-PLAN STATE AWARE)
// /// ─────────────────────────────────────────────
// class _PlanCard extends StatelessWidget {
//   final SubscriptionPlan plan;
//   final bool isDark;
//   final SubscriptionController controller;

//   _PlanCard({
//     required this.plan,
//     required this.isDark,
//     required this.controller,
//   });

//   final TextEditingController couponController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final Color bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
//     final Color borderColor = plan.isRecommended
//         ? Colors.orange
//         : Colors.transparent;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: borderColor, width: 2),
//         boxShadow: [
//           if (!isDark)
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 6),
//             ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// ⭐ Recommended badge
//             if (plan.isRecommended)
//               Align(
//                 alignment: Alignment.topRight,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.orange,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Text(
//                     'RECOMMENDED',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 11,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),

//             Text(
//               plan.planName,
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 6),

//             Text(
//               '₹${plan.amount} / ${plan.durationDays} days',
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 color: Colors.green,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),

//             const Divider(height: 32),

//             /// ✅ Features
//             ...plan.features.map(
//               (f) => Padding(
//                 padding: const EdgeInsets.only(bottom: 6),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.check_circle,
//                       size: 18,
//                       color: Colors.green,
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         f.featureTitle,
//                         style: GoogleFonts.poppins(fontSize: 14),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             /// 🏷 COUPON FIELD
//             TextField(
//               controller: couponController,
//               onChanged: (_) => controller.couponErrorMap.remove(plan.id),
//               decoration: InputDecoration(
//                 hintText: 'Enter coupon code',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 suffixIcon: Obx(() {
//                   final isLoading = controller.isPurchasingFor(plan.id);

//                   return isLoading
//                       ? const Padding(
//                           padding: EdgeInsets.all(12),
//                           child: SizedBox(
//                             height: 16,
//                             width: 16,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           ),
//                         )
//                       : TextButton(
//                           onPressed: () {
//                             controller.applyCoupon(
//                               planId: plan.id,
//                               couponCode: couponController.text.trim(),
//                             );
//                           },
//                           child: const Text('Apply'),
//                         );
//                 }),
//               ),
//             ),

//             /// ❌ Coupon error (PER PLAN)
//             Obx(() {
//               final error = controller.couponErrorFor(plan.id);

//               if (error.isEmpty) return const SizedBox();

//               return Padding(
//                 padding: const EdgeInsets.only(top: 6),
//                 child: Text(
//                   error,
//                   style: const TextStyle(color: Colors.red, fontSize: 13),
//                 ),
//               );
//             }),

//             const SizedBox(height: 12),

//             /// 💰 PRICE (PER PLAN)
//             Obx(() {
//               final data = controller.purchaseDataFor(plan.id);

//               if (data == null) {
//                 return Text(
//                   'Payable Amount: ₹${plan.amount}',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 );
//               }

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Base Amount: ₹${data.baseAmount}'),
//                   if (data.couponDiscount != '0.00')
//                     Text(
//                       'Coupon Discount: -₹${data.couponDiscount}',
//                       style: const TextStyle(color: Colors.green),
//                     ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Payable Amount: ₹${data.finalPayableAmount}',
//                     style: GoogleFonts.poppins(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                     ),
//                   ),
//                 ],
//               );
//             }),

//             const SizedBox(height: 16),

//             /// 🛒 PAY BUTTON (PER PLAN)
//             /// 🛒 PAY BUTTON (PER PLAN)
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   _showPurchaseSummary(context, controller, plan);
//                 },
//                 child: const Text('Proceed to Payment'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ─────────────────────────────────────────────
//   /// 💳 PURCHASE SUMMARY (PER PLAN)
//   /// ─────────────────────────────────────────────
//   void _showPurchaseSummary(
//     BuildContext context,
//     SubscriptionController controller,
//     SubscriptionPlan plan,
//   ) {
//     // ✅ Coupon data (may be null)
//     final purchaseData = controller.purchaseDataFor(plan.id);

//     // ✅ Final payable amount (coupon OR base price)
//     final String payableAmount =
//         purchaseData?.finalPayableAmount ?? plan.amount.toString();

//     // ✅ Profile data
//     final ProfileController profileController = Get.find<ProfileController>();

//     final emailController = TextEditingController(
//       text: profileController.email,
//     );

//     final mobileController = TextEditingController(
//       text: profileController.mobile,
//     );

//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// 🧾 Title
//             Text(
//               'Confirm Purchase',
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 12),

//             // /// 👤 USER INFO
//             // Text(
//             //   'Name',
//             //   style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
//             // ),
//             // Text(
//             //   profileController.name,
//             //   style: GoogleFonts.poppins(
//             //     fontSize: 15,
//             //     fontWeight: FontWeight.w500,
//             //   ),
//             // ),
//             const SizedBox(height: 10),

//             Text(
//               'Email',
//               style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
//             ),
//             TextFormField(
//               controller: emailController,
//               readOnly: true,
//               decoration: const InputDecoration(border: OutlineInputBorder()),
//             ),

//             const SizedBox(height: 10),

//             Text(
//               'Mobile',
//               style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
//             ),
//             TextFormField(
//               controller: mobileController,
//               readOnly: true,
//               decoration: const InputDecoration(border: OutlineInputBorder()),
//             ),

//             const SizedBox(height: 16),

//             /// 📦 Plan info
//             Text('Plan: ${plan.planName}'),
//             Text('Duration: ${plan.durationDays} days'),

//             const SizedBox(height: 8),

//             /// 💰 Amount
//             Text(
//               'Payable Amount: ₹$payableAmount',
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.green,
//               ),
//             ),

//             const SizedBox(height: 20),

//             /// 💳 Pay button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Get.back();

//                   Future.delayed(const Duration(milliseconds: 300), () {
//                     final razorpayService = RazorpayService();

//                     final int amount = double.parse(
//                       payableAmount,
//                     ).round(); // ✅ SAFE FOR 999.00

//                     razorpayService.startPayment(
//                       amount: amount,
//                       description: plan.planName,
//                       email: emailController.text,
//                       contact: mobileController.text,
//                     );
//                   });
//                 },

//                 child: const Text('Pay Now'),
//               ),
//             ),
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//     );
//   }
// }

import 'package:Gixa/Modules/Auth/model/Auth/user_model.dart';
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/subscription/model/subscription_purchase_model.dart';
import 'package:Gixa/Modules/subscription/view/subscription_history_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/subscription_controller.dart';
import '../model/subscription_plan.dart';

class SubscriptionPage extends StatelessWidget {
  
  SubscriptionPage({super.key});

  final controller = Get.put(SubscriptionController());

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
            icon: const Icon(Icons.history, color: Colors.white, size: 20),
            label: const Text('History', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),

      body: Obx(() {
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
                  TextField(
                    controller: couponController,
                    decoration: InputDecoration(
                      hintText: 'Enter coupon code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: TextButton(
                        onPressed: () {
                          controller.applyCoupon(
                            planId: plan.id,
                            couponCode: couponController.text
                                .trim()
                                .toUpperCase(),
                          );
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  ),

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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () =>
                          _openConfirmSheet(context, plan, preview, payable),
                      child: const Text('Proceed to Payment'),
                    ),
                  ),
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
