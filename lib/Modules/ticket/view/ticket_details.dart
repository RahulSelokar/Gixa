import 'package:Gixa/Modules/ticket/model/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:Gixa/common/app_colors.dart';
import '../controller/ticket_controller.dart';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:file_picker/file_picker.dart';

import 'package:open_filex/open_filex.dart';

import 'package:photo_view/photo_view.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';

class TicketDetailsView extends StatelessWidget {
  TicketDetailsView({super.key});

  final TicketController controller = Get.find<TicketController>();

  static const Color kPrimaryBlue = kHomeAccentColor;

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "open":
        return Colors.orange;
      case "closed":
        return Colors.green;
      case "pending":
        return kHomeAccentColor;
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
        return Icons.hourglass_bottom_rounded;
      case "in_progress":
      case "in progress":
        return Icons.sync_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  String _formatDate(String rawDate) {
    final value = rawDate.trim();
    if (value.isEmpty) return "Date not available";

    final parsed = DateTime.tryParse(value.replaceFirst(' ', 'T'));
    if (parsed == null) return value;

    return DateFormat('dd-MM-yyyy hh:mm a').format(parsed);
  }

  bool _isImage(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.bmp');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FD);
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111111);
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Ticket Details",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: textColor,
          ),
        ),
        backgroundColor: surfaceColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        scrolledUnderElevation: 0,
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
              style: GoogleFonts.inter(fontSize: 14, color: subTextColor),
            ),
          );
        }

        final statusColor = _statusColor(ticket.status);
        final subject = ticket.subject.trim().isEmpty
            ? "Untitled Ticket"
            : ticket.subject.trim();
        final description = ticket.description.trim().isEmpty
            ? "No description provided."
            : ticket.description.trim();

        return Column(
          children: [
            /// HEADER
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),

                children: [
                  /// TOP CARD
                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(24),

                      border: Border.all(color: borderColor),

                      boxShadow: isDark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),

                                blurRadius: 16,

                                offset: const Offset(0, 6),
                              ),
                            ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),

                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.12),

                                borderRadius: BorderRadius.circular(14),
                              ),

                              child: Icon(
                                _statusIcon(ticket.status),

                                color: statusColor,
                                size: 24,
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    subject,

                                    style: GoogleFonts.inter(
                                      fontSize: 19,

                                      fontWeight: FontWeight.w700,

                                      color: textColor,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,

                                    children: [
                                      _MetaChip(
                                        label: ticket.status.toUpperCase(),

                                        backgroundColor: statusColor
                                            .withOpacity(0.12),

                                        textColor: statusColor,
                                      ),

                                      if (ticket.ticketNumber.isNotEmpty)
                                        _MetaChip(
                                          label: "#${ticket.ticketNumber}",

                                          backgroundColor: kPrimaryBlue
                                              .withOpacity(0.10),

                                          textColor: kPrimaryBlue,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Text(
                          description,

                          style: GoogleFonts.inter(
                            fontSize: 14,
                            height: 1.6,
                            color: textColor,
                          ),
                        ),
                        // Support message added to header for better visibility
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Our support team will contact you within 24 hours regarding this ticket.",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                              color: subTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// CHAT SECTION
                  if (ticket.messages.isEmpty)
                    _EmptyReplies(subTextColor: subTextColor)
                  else
                    Column(
                      children: ticket.messages.expand((msg) {
                        final isMine = msg.senderRole.toLowerCase() == 'student';
                        List<Widget> bubbles = [];

                        final images = msg.attachments.where((f) => _isImage(f.file)).toList();
                        final docs = msg.attachments.where((f) => !_isImage(f.file)).toList();
                        final text = msg.message.trim();

                        // 1. Documents (Separate bubble for each document)
                        for (var doc in docs) {
                          bubbles.add(Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _ChatBubble(
                              message: msg.copyWith(
                                message: '', // No text on docs unless it's the only attachment
                                attachments: [doc],
                              ),
                              isMine: isMine,
                              isDark: isDark,
                              isImageOnly: false,
                            ),
                          ));
                        }

                        // 2. Images (Grouped in one bubble)
                        if (images.isNotEmpty) {
                          bubbles.add(Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _ChatBubble(
                              message: msg.copyWith(
                                message: text, // Text goes as caption for images
                                attachments: images,
                              ),
                              isMine: isMine,
                              isDark: isDark,
                              isImageOnly: true,
                            ),
                          ));
                        } else if (text.isNotEmpty && docs.isEmpty) {
                          // 3. Text only
                          bubbles.add(Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _ChatBubble(
                              message: msg,
                              isMine: isMine,
                              isDark: isDark,
                              isImageOnly: false,
                            ),
                          ));
                        } else if (text.isNotEmpty && docs.isNotEmpty) {
                          // Text goes with the last doc if there were no images
                          bubbles.add(Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _ChatBubble(
                              message: msg.copyWith(
                                message: text,
                                attachments: [],
                              ),
                              isMine: isMine,
                              isDark: isDark,
                              isImageOnly: false,
                            ),
                          ));
                        }

                        return bubbles;
                      }).toList(),
                    ),
                ],
              ),
            ),

            /// BOTTOM CHAT BAR
            _TicketReplyComposer(controller: controller, isDark: isDark),
          ],
        );
      }),
    );
  }
}

class _TicketReplyComposer extends StatelessWidget {
  const _TicketReplyComposer({required this.controller, required this.isDark});

  final TicketController controller;

  final bool isDark;

  bool _isImageFile(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.bmp');
  }

  IconData _getFileIcon(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.pdf')) return Icons.picture_as_pdf;
    if (lower.endsWith('.doc') || lower.endsWith('.docx'))
      return Icons.description;
    if (lower.endsWith('.xls') || lower.endsWith('.xlsx'))
      return Icons.table_chart;
    return Icons.insert_drive_file;
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final tc = isDark ? Colors.white : Colors.black87;
        return Container(
          margin: const EdgeInsets.only(left: 12, right: 12, bottom: 80),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AttachmentIcon(
                  icon: Icons.insert_drive_file,
                  color: Colors.indigoAccent,
                  label: "Document",
                  textColor: tc,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    controller.pickReplyFiles();
                  },
                ),
                _AttachmentIcon(
                  icon: Icons.camera_alt,
                  color: Colors.pinkAccent,
                  label: "Camera",
                  textColor: tc,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    controller.pickReplyImage(ImageSource.camera);
                  },
                ),
                _AttachmentIcon(
                  icon: Icons.photo,
                  color: Colors.purpleAccent,
                  label: "Gallery",
                  textColor: tc,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    controller.pickReplyImages();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,

          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            /// FILES
            Obx(() {
              if (controller.replyAttachments.isEmpty) {
                return const SizedBox();
              }

              return SizedBox(
                height: 70,

                child: ListView.builder(
                  scrollDirection: Axis.horizontal,

                  itemCount: controller.replyAttachments.length,

                  itemBuilder: (_, i) {
                    final file = controller.replyAttachments[i];
                    final isImage = _isImageFile(file.path);

                    return Container(
                      margin: const EdgeInsets.only(right: 10),

                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2A2A2A)
                            : Colors.grey.shade200,

                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isImage)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                file,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Icon(
                              _getFileIcon(file.path),
                              color: isDark ? Colors.white70 : Colors.black54,
                              size: 20,
                            ),

                          const SizedBox(width: 8),

                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 120),
                            child: Text(
                              file.path.split('/').last.split('\\').last,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),

                          const SizedBox(width: 4),

                          IconButton(
                            onPressed: () {
                              controller.removeReplyAttachment(i);
                            },

                            icon: const Icon(Icons.close),
                            iconSize: 16,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),

            Row(
              children: [
                IconButton(
                  onPressed: () => _showAttachmentOptions(context),

                  icon: const Icon(Icons.attach_file),
                ),

                Expanded(
                  child: TextField(
                    controller: controller.messageTec,

                    minLines: 1,
                    maxLines: 5,

                    decoration: InputDecoration(
                      hintText: 'Type message...',

                      filled: true,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),

                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Obx(() {
                  return CircleAvatar(
                    backgroundColor: TicketDetailsView.kPrimaryBlue,

                    child: IconButton(
                      onPressed: controller.isSendingReply.value
                          ? null
                          : controller.sendReply,

                      icon: controller.isSendingReply.value
                          ? const SizedBox(
                              height: 18,
                              width: 18,

                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded, color: Colors.white),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.surfaceColor,
    required this.borderColor,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Color surfaceColor;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: TicketDetailsView.kPrimaryBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _AttachmentIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final Color textColor;
  final VoidCallback onTap;

  const _AttachmentIcon({
    required this.icon,
    required this.color,
    required this.label,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.message,
    required this.isMine,
    required this.isDark,
    this.isImageOnly = false,
  });

  final TicketMessage message;
  final bool isMine;
  final bool isDark;
  final bool isImageOnly;

  bool _isImage(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.bmp');
  }

  bool _isPdf(String url) {
    return url.toLowerCase().endsWith('.pdf');
  }

  Future<void> _openAttachmentFile(
    BuildContext context,
    String url,
    String name,
  ) async {
    try {
      Get.dialog(
        const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: TicketDetailsView.kPrimaryBlue,
                  ),
                  SizedBox(height: 16),
                  Text("Downloading file...", style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      final fileName = name.isNotEmpty
          ? name
          : url.split('/').last.split('\\').last;
      final localPath = "${Directory.systemTemp.path}/$fileName";

      final response = await dio.Dio().download(url, localPath);

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (response.statusCode == 200) {
        final result = await OpenFilex.open(localPath);
        if (result.type != ResultType.done) {
          AppSnackbar.show("Error", "Could not open file: ${result.message}");
        }
      } else {
        AppSnackbar.show("Error", "Failed to download file from server");
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      AppSnackbar.show("Error", "Failed to open file: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the style of the bubble
    final bubbleColor = isImageOnly
        ? Colors.transparent
        : isMine
            ? TicketDetailsView.kPrimaryBlue
            : (isDark ? const Color(0xFF2A2A2A) : Colors.white);

    final padding = isImageOnly ? EdgeInsets.zero : const EdgeInsets.all(14);

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: padding,
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.attachments.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: message.message.isNotEmpty ? 12 : 0),
                child: isImageOnly
                    ? _buildImageGrid(message.attachments)
                    : Column(
                        children: message.attachments.map((file) {
                          final url = file.file;
                          final isImage = _isImage(url);

                          return GestureDetector(
                            onTap: () {
                              if (isImage) {
                                Get.to(
                                  () => Scaffold(
                                    backgroundColor: Colors.black,
                                    body: PhotoView(imageProvider: NetworkImage(url)),
                                  ),
                                );
                              } else {
                                _openAttachmentFile(context, url, file.name);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: isImage
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: CachedNetworkImage(
                                        imageUrl: url,
                                        height: 180,
                                        width: 220,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: isMine
                                            ? Colors.white.withOpacity(0.15)
                                            : (isDark
                                                ? Colors.white.withOpacity(0.08)
                                                : Colors.black.withOpacity(0.05)),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _isPdf(url)
                                                ? Icons.picture_as_pdf
                                                : Icons.description,
                                            color: isMine
                                                ? Colors.white
                                                : (isDark
                                                    ? Colors.white
                                                    : Colors.black87),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              file.name,
                                              style: GoogleFonts.inter(
                                                color: isMine
                                                    ? Colors.white
                                                    : (isDark
                                                        ? Colors.white
                                                        : Colors.black87),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
            if (message.message.isNotEmpty)
              Container(
                padding: isImageOnly
                    ? const EdgeInsets.symmetric(horizontal: 14, vertical: 10)
                    : EdgeInsets.zero,
                decoration: isImageOnly
                    ? BoxDecoration(
                        color: isMine
                            ? TicketDetailsView.kPrimaryBlue
                            : (isDark ? const Color(0xFF2A2A2A) : Colors.white),
                        borderRadius: BorderRadius.circular(18),
                      )
                    : null,
                child: Text(
                  message.message,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: isMine
                        ? Colors.white
                        : (isDark ? Colors.white : Colors.black),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              message.createdAt,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: isMine ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid(List<TicketAttachment> images) {
    if (images.length == 1) {
      return GestureDetector(
        onTap: () {
          Get.to(
            () => Scaffold(
              backgroundColor: Colors.black,
              body: PhotoView(imageProvider: NetworkImage(images.first.file)),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: CachedNetworkImage(
            imageUrl: images.first.file,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: images.map((img) {
        return GestureDetector(
          onTap: () {
            Get.to(
              () => Scaffold(
                backgroundColor: Colors.black,
                body: PhotoView(imageProvider: NetworkImage(img.file)),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: img.file,
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _EmptyReplies extends StatelessWidget {
  const _EmptyReplies({required this.subTextColor});

  final Color subTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: TicketDetailsView.kPrimaryBlue.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.mark_chat_unread_outlined,
            color: TicketDetailsView.kPrimaryBlue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "No replies yet. Our support team will update this ticket soon.",
              style: GoogleFonts.inter(fontSize: 13, color: subTextColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
