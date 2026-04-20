import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ticket_controller.dart';

class TicketDetailsView extends StatelessWidget {
  TicketDetailsView({super.key});

  final TicketController controller = Get.find<TicketController>();

  Color _statusColor(String status, BuildContext context) {
    switch (status.toLowerCase()) {
      case "open":
        return Colors.orange;
      case "closed":
        return Colors.green;
      case "pending":
        return Colors.blue;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ticket Details"),
        centerTitle: true,
      ),

      body: Obx(() {

        if (controller.isDetailsLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final ticket = controller.selectedTicket.value;

        if (ticket == null) {
          return Center(
            child: Text(
              "No details found",
              style: textTheme.bodyMedium,
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔹 Ticket Header
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [

                          Expanded(
                            child: Text(
                              ticket.subject,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _statusColor(ticket.status, context)
                                  .withOpacity(.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              ticket.status.toUpperCase(),
                              style: textTheme.labelSmall?.copyWith(
                                color:
                                    _statusColor(ticket.status, context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [

                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            ticket.createdAt,
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 Description
              Text(
                "Description",
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    ticket.description,
                    style: textTheme.bodyMedium,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// 🔹 Replies Header
              Row(
                children: [

                  Icon(
                    Icons.chat_bubble_outline,
                    color: theme.colorScheme.primary,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    "Replies",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// 🔹 Replies List
              if (ticket.replies.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "No replies yet",
                    style: textTheme.bodyMedium,
                  ),
                ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ticket.replies.length,
                itemBuilder: (context, index) {

                  final reply = ticket.replies[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [

                              Text(
                                reply.replyBy,
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                reply.createdAt,
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          Text(
                            reply.message,
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}