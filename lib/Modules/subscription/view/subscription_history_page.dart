import 'package:Gixa/Modules/subscription/controller/subsciption_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SubscriptionHistoryPage extends StatelessWidget {
  const SubscriptionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

final controller = Get.put(SubscriptionHistoryController());

    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF6F7FB);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Subscription History"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (controller.historyList.isEmpty) {
          return const Center(
            child: Text(
              "No subscription history found",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: controller.historyList.length,
          itemBuilder: (context, index) {
            final item = controller.historyList[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ── HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.plan.planName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _statusChip(item),
                      ],
                    ),

                    const SizedBox(height: 14),

                    /// ── AMOUNT
                    Text(
                      "₹${item.finalAmount}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: item.isActive
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// ── PAYMENT STATUS
                    Row(
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: _paymentColor(item.paymentStatus),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.paymentStatus,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _paymentColor(item.paymentStatus),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    /// ── PAYMENT INFO BOX
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.04)
                            : Colors.grey.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          _infoRow(
                            "Order ID",
                            item.razorpayOrderId ?? "-",
                            subTextColor,
                          ),
                          _infoRow(
                            "Payment ID",
                            item.razorpayPaymentId ?? "-",
                            subTextColor,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// ── DATE SECTION
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "Subscription Period",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: subTextColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// FROM → TO
                    if (item.startDate != null && item.endDate != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: subTextColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _dateBox("From", item.startDate!, isDark),
                            const Icon(Icons.arrow_forward_rounded, size: 18),
                            _dateBox("To", item.endDate!, isDark),
                          ],
                        ),
                      ),

                    const SizedBox(height: 10),

                    /// PURCHASE DATE
                    Text(
                      "Purchased on ${_formatDate(item.createdAt)}",
                      style: TextStyle(fontSize: 12, color: subTextColor),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _dateBox(String label, DateTime date, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat("dd MMM yyyy").format(date.toLocal()),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  /// ─────────────────────────────────────
  /// STATUS CHIP
  /// ─────────────────────────────────────
  Widget _statusChip(item) {
    Color color;
    String label;

    if (item.isActive) {
      color = Colors.green;
      label = "ACTIVE";
    } else if (item.status == "FAILED") {
      color = Colors.red;
      label = "FAILED";
    } else {
      color = Colors.orange;
      label = "PENDING";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// ─────────────────────────────────────
  /// INFO ROW
  /// ─────────────────────────────────────
  Widget _infoRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: color)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  /// ─────────────────────────────────────
  /// PAYMENT COLOR
  /// ─────────────────────────────────────
  Color _paymentColor(String status) {
    switch (status) {
      case "SUCCESS":
        return Colors.green;
      case "FAILED":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  /// ─────────────────────────────────────
  /// DATE FORMAT
  /// ─────────────────────────────────────
  String _formatDate(DateTime date) {
    return DateFormat("dd MMM yyyy • hh:mm a").format(date.toLocal());
  }
}
