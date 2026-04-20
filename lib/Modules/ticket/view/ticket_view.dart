import 'package:Gixa/Modules/ticket/view/ticket_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/ticket_controller.dart';

class CreateTicketView extends StatelessWidget {
  CreateTicketView({super.key});

  final TicketController controller = Get.put(TicketController());

  final TextEditingController subjectController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  static const Color kPrimaryBlue = Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FD);
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111111);
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final inputBg = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Support Tickets",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: textColor,
          ),
        ),
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textColor),
        scrolledUnderElevation: 0,
      ),
      body: Obx(() {
        return Column(
          children: [
            /// =============================
            /// CREATE TICKET FORM
            /// =============================
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kPrimaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.add_circle_outline,
                          color: kPrimaryBlue,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Create New Ticket",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: subjectController,
                    style: GoogleFonts.inter(fontSize: 14, color: textColor),
                    decoration: InputDecoration(
                      labelText: "Subject",
                      labelStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: subTextColor,
                      ),
                      filled: true,
                      fillColor: inputBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: kPrimaryBlue,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (value) => controller.subject.value = value,
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    style: GoogleFonts.inter(fontSize: 14, color: textColor),
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: subTextColor,
                      ),
                      alignLabelWithHint: true,
                      filled: true,
                      fillColor: inputBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: kPrimaryBlue,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (value) => controller.description.value = value,
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              controller.createTicket();
                              subjectController.clear();
                              descriptionController.clear();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Submit Ticket",
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            /// =============================
            /// PREVIOUS TICKETS HEADER
            /// =============================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "PREVIOUS TICKETS",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: subTextColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            /// =============================
            /// TICKET LIST
            /// =============================
            Expanded(
              child: controller.isListLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(color: kPrimaryBlue),
                    )
                  : controller.tickets.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.confirmation_number_outlined,
                            size: 56,
                            color: subTextColor.withOpacity(0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No tickets yet",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: subTextColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Create a ticket to get support",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: subTextColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: controller.fetchTickets,
                      color: kPrimaryBlue,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.tickets.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final ticket = controller.tickets[index];

                          return _TicketCard(
                            ticket: ticket,
                            isDark: isDark,
                            surfaceColor: surfaceColor,
                            textColor: textColor,
                            subTextColor: subTextColor,
                            borderColor: borderColor,
                            onTap: () async {
                              final ok = await controller.fetchTicketDetails(
                                ticket.id,
                              );
                              if (ok) {
                                Get.to(() => TicketDetailsView());
                              } else {
                                Get.snackbar(
                                  "Error",
                                  controller.errorMessage.value.isEmpty
                                      ? "Failed to load ticket details"
                                      : controller.errorMessage.value,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}

/// ───────────── TICKET CARD ─────────────
class _TicketCard extends StatelessWidget {
  final dynamic ticket;
  final bool isDark;
  final Color surfaceColor;
  final Color textColor;
  final Color subTextColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _TicketCard({
    required this.ticket,
    required this.isDark,
    required this.surfaceColor,
    required this.textColor,
    required this.subTextColor,
    required this.borderColor,
    required this.onTap,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "open":
        return Colors.orange;
      case "closed":
        return Colors.green;
      case "pending":
        return Colors.blue;
      case "in_progress":
      case "in progress":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case "open":
        return Icons.circle_outlined;
      case "closed":
        return Icons.check_circle_outline;
      case "pending":
        return Icons.hourglass_empty_rounded;
      case "in_progress":
      case "in progress":
        return Icons.sync_rounded;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = ticket.status;
    final color = _statusColor(status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            /// Status Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_statusIcon(status), color: color, size: 22),
            ),
            const SizedBox(width: 14),

            /// Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.subject,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: color.withOpacity(0.2)),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ),
                      if (ticket.ticketNumber.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          "#${ticket.ticketNumber}",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: subTextColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            /// Arrow
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: subTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
