import 'dart:async';

import 'package:Gixa/Modules/predication/view/predication_view.dart';
import 'package:Gixa/services/auth_guard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/neet_rank_controller.dart';

class NeetRankView extends StatelessWidget {
  NeetRankView({super.key});

  final controller = Get.put(NeetRankController());

  /// 🎨 GIXA Gradient (same for both themes)
  final gradient = const LinearGradient(
    colors: [
      Color(0xffFF7A18),
      Color(0xffFF006E),
      Color(0xff8338EC),
      Color(0xff3A86FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 🌗 THEME HELPERS
  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  Color bg(BuildContext context) =>
      isDark(context) ? const Color(0xff0F172A) : const Color(0xffF8FAFC);

  Color card(BuildContext context) =>
      isDark(context) ? const Color(0xff1E293B) : Colors.white;

  Color textPrimary(BuildContext context) =>
      isDark(context) ? Colors.white : const Color(0xff0F172A);

  Color textSecondary(BuildContext context) =>
      isDark(context) ? Colors.white70 : Colors.black54;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      appBar: AppBar(
        title: const Text("NEET Rank Predictor"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textPrimary(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInput(context),
            const SizedBox(height: 20),
            _buildButton(),
            const SizedBox(height: 30),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = controller.result.value;

                if (data == null) {
                  return _emptyState(context);
                }

                return _resultUI(context, data);
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔢 INPUT
  Widget _buildInput(BuildContext context) {
    Timer? _debounce;

    return TextFormField(
      controller: controller.scoreController,
      keyboardType: TextInputType.number,

      /// 🔢 INPUT RULES
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],

      style: TextStyle(color: textPrimary(context)),

      decoration: InputDecoration(
        labelText: "NEET Score",
        hintText: "Auto-filled from profile (editable)",
        filled: true,
        fillColor: card(context),

        prefixIcon: Icon(
          Icons.analytics_outlined,
          color: textSecondary(context),
        ),

        suffixIcon: controller.scoreController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  controller.scoreController.clear();
                  controller.reset();
                },
              )
            : null,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: textPrimary(context), width: 1.2),
        ),
      ),

      /// 🔥 SMART HANDLING
      onChanged: (value) {
        /// allow empty (user clearing)
        if (value.isEmpty) {
          controller.reset();
          return;
        }

        final score = int.tryParse(value);
        if (score == null) return;

        /// 🚫 LIMIT MAX VALUE
        if (score > 720) {
          controller.scoreController.text = "720";
          controller.scoreController.selection = const TextSelection.collapsed(
            offset: 3,
          );
          return;
        }

        /// ⏳ DEBOUNCE API CALL
        if (_debounce?.isActive ?? false) _debounce!.cancel();

        _debounce = Timer(const Duration(milliseconds: 500), () {
          controller.predictRank(score);
        });
      },
    );
  }

  /// 🚀 BUTTON
  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: InkWell(
        onTap: controller.predictRank,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Text(
              "Predict Rank",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// EMPTY STATE
  Widget _emptyState(BuildContext context) {
    return Center(
      child: Text(
        "Enter your score to see prediction",
        style: TextStyle(color: textSecondary(context)),
      ),
    );
  }

  /// 🔥 RESULT UI
  Widget _resultUI(BuildContext context, data) {
    final hasValidRange =
        data.predictedAirRange.fromRank != null &&
        data.predictedAirRange.toRank != null;

    return SingleChildScrollView(
      child: Column(
        children: [
          /// 🎯 MAIN CARD (GRADIENT stays same)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDark(context)
                      ? Colors.purple.withOpacity(0.3)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Predicted AIR",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  data.predictedAir.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (hasValidRange) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.bar_chart, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        "Range: ${data.predictedAirRange.fromRank} - ${data.predictedAirRange.toRank}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
                // Row(
                //   children: [
                //     const Icon(Icons.people, color: Colors.white),
                //     const SizedBox(width: 8),
                //     Text(
                //       "${data.sameScoreCandidates} students scored same",
                //       style: const TextStyle(color: Colors.white),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// ⚠️ NOTE CARD (adaptive)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark(context)
                  ? Colors.orange.withOpacity(0.15)
                  : Colors.orange.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.orange),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "⚠️ Important Note",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                // Text(
                //   "This is a Tentative Rank based on last year's ranking.",
                //   style: TextStyle(color: textPrimary(context)),
                // ),
                // const SizedBox(height: 6),
                Text(
                  data.tentativeMessage,
                  style: TextStyle(color: textSecondary(context)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          /// 🚀 CTA
          InkWell(
            onTap: () {
              AuthGuard.checkAccess(
                onAllowed: () {
                  Get.to(PredictionView());
                },
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: gradient,
              ),
              child: const Center(
                child: Text(
                  "🎓 Predict Colleges",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
