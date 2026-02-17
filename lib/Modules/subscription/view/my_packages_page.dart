import 'package:Gixa/Modules/subscription/controller/subsciption_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyPackagesPage extends StatelessWidget {
  const MyPackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.put(SubscriptionHistoryController());

    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF6F7FB);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("My Packages"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: bgColor,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        /// 🔥 FILTER ONLY PURCHASED PLANS
        final purchasedPlans = controller.historyList
            .where((item) =>
                item.paymentStatus == "SUCCESS" && item.isActive)
            .toList();

        if (purchasedPlans.isEmpty) {
          return const Center(
            child: Text(
              "No active packages found",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: purchasedPlans.length,
          itemBuilder: (context, index) {
            final item = purchasedPlans[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// PLAN NAME
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.plan.planName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      _activeChip(),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// AMOUNT
                  Text(
                    "₹${item.finalAmount}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// VALIDITY SECTION
                  if (item.startDate != null && item.endDate != null)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _dateBox("Start",
                              item.startDate!),
                          const Icon(Icons.arrow_forward_rounded, size: 18),
                          _dateBox("Expiry",
                              item.endDate!),
                        ],
                      ),
                    ),

                  const SizedBox(height: 12),

                  Text(
                    "Purchased on ${DateFormat("dd MMM yyyy").format(item.createdAt.toLocal())}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
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

  /// ACTIVE CHIP
  Widget _activeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "ACTIVE",
        style: TextStyle(
          color: Colors.green,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _dateBox(String label, DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat("dd MMM yyyy").format(date.toLocal()),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
