import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Gixa/common/app_colors.dart';
import '../controller/rank_analysis_controller.dart';

class RankAnalysisScreen extends StatefulWidget {
  RankAnalysisScreen({super.key});

  @override
  State<RankAnalysisScreen> createState() => _RankAnalysisScreenState();
}

class _RankAnalysisScreenState extends State<RankAnalysisScreen> {
  final controller = Get.put(RankAnalysisController());

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;

    controller.fetchRankAnalysis(
      collegeCode: args['college_code'],
      course: args['course'],
      category: args['category'],
      userRank: args['rank'],
    );
  }

  Color chanceColor(String chance) {
    switch (chance.toLowerCase()) {
      case "high":
        return Colors.green;
      case "moderate":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

    controller.fetchRankAnalysis(
      collegeCode: args['college_code'],
      course: args['course'],
      category: args['category'],
      userRank: args['rank'],
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xff121212)
          : const Color(0xffF5F7FB),
      appBar: AppBar(
        title: const Text("Rank Analysis"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.rankAnalysis.value;

        if (data == null) {
          return const Center(child: Text("No Data Found"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------------- COLLEGE INFO ----------------
              _card(
                isDark,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// College Icon
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: kHomeAccentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.school,
                        color: kHomeAccentColor,
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// College Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// College Name
                          Text(
                            data.college.collegeName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// Course Row
                          Row(
                            children: [
                              const Icon(
                                Icons.menu_book,
                                size: 16,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Course : ${data.college.course}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          /// Code Row
                          Row(
                            children: [
                              const Icon(
                                Icons.confirmation_number,
                                size: 16,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Code : ${data.college.collegeCode}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ---------------- RANK COMPARISON ----------------
              _card(
                isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.analytics, color: Colors.orange),
                        SizedBox(width: 6),
                        Text(
                          "Rank Comparison",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        /// YOUR RANK CARD
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEC8B04).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Color(0xFFEC8B04),
                                ),

                                const SizedBox(height: 6),

                                const Text(
                                  "Your Rank",
                                  style: TextStyle(color: Colors.grey),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  data.rankComparison.userRank.toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFEC8B04),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// LAST CUTOFF CARD
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.flag,
                                  color: Colors.deepPurple,
                                ),

                                const SizedBox(height: 6),

                                const Text(
                                  "Last Cutoff",
                                  style: TextStyle(color: Colors.grey),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  data.rankComparison.lastYearCutoff.toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// DIFFERENCE
                    Row(
                      children: [
                        const Icon(
                          Icons.compare_arrows,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Difference : ${data.rankComparison.difference}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// PROGRESS INDICATOR
                    LinearProgressIndicator(
                      value: 0.5, // you can calculate based on rank difference
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                    ),

                    const SizedBox(height: 10),

                    /// CHANCE BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Chance : ${data.rankComparison.chance}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // const SizedBox(height: 20),

              /// ---------------- CUTOFF TREND ----------------
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Row(
              //       children: const [
              //         Icon(Icons.show_chart, color: Colors.orange),
              //         SizedBox(width: 6),
              //         Text(
              //           "Cutoff Trend",
              //           style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ],
              //     ),

              //     const SizedBox(height: 14),

              //     ...data.cutoffTrend.map((trend) {
              //       return Container(
              //         margin: const EdgeInsets.only(bottom: 10),
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 16,
              //           vertical: 14,
              //         ),
              //         decoration: BoxDecoration(
              //           color: isDark ? const Color(0xff1E1E1E) : Colors.white,
              //           borderRadius: BorderRadius.circular(14),
              //           border: Border.all(
              //             color: isDark
              //                 ? Colors.white.withOpacity(0.06)
              //                 : Colors.grey.shade200,
              //           ),
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             /// YEAR
              //             Row(
              //               children: [
              //                 const Icon(
              //                   Icons.calendar_today,
              //                   size: 18,
              //                   color: Colors.blue,
              //                 ),
              //                 const SizedBox(width: 8),
              //                 Text(
              //                   trend.year.toString(),
              //                   style: const TextStyle(
              //                     fontWeight: FontWeight.w600,
              //                     fontSize: 15,
              //                   ),
              //                 ),
              //               ],
              //             ),

              //             /// RANK
              //             Row(
              //               children: [
              //                 const Icon(
              //                   Icons.trending_up,
              //                   color: Colors.green,
              //                   size: 18,
              //                 ),
              //                 const SizedBox(width: 6),

              //                 Container(
              //                   padding: const EdgeInsets.symmetric(
              //                     horizontal: 10,
              //                     vertical: 4,
              //                   ),
              //                   decoration: BoxDecoration(
              //                     color: Colors.green.withOpacity(.12),
              //                     borderRadius: BorderRadius.circular(20),
              //                   ),
              //                   child: Text(
              //                     "Rank ${trend.closingRank}",
              //                     style: const TextStyle(
              //                       color: Colors.green,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       );
              //     }),
              //   ],
              // ),

              // const SizedBox(height: 20),

              /// ---------------- YEAR WISE ROUND CUTOFF ----------------
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     /// Section Title
              //     Row(
              //       children: const [
              //         Icon(Icons.timeline, color: Colors.deepPurple),
              //         SizedBox(width: 6),
              //         Text(
              //           "Year Wise Round Cutoff",
              //           style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ],
              //     ),

              //     const SizedBox(height: 14),

              //     ...data.yearWiseCutoff.map((yearData) {
              //       return Container(
              //         margin: const EdgeInsets.only(bottom: 14),
              //         padding: const EdgeInsets.all(16),
              //         decoration: BoxDecoration(
              //           color: isDark ? const Color(0xff1E1E1E) : Colors.white,
              //           borderRadius: BorderRadius.circular(16),
              //           border: Border.all(
              //             color: isDark
              //                 ? Colors.white.withOpacity(0.05)
              //                 : Colors.grey.shade200,
              //           ),
              //         ),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             /// YEAR HEADER
              //             Row(
              //               children: [
              //                 Container(
              //                   padding: const EdgeInsets.symmetric(
              //                     horizontal: 12,
              //                     vertical: 6,
              //                   ),
              //                   decoration: BoxDecoration(
              //                     color: Colors.deepPurple.withOpacity(.12),
              //                     borderRadius: BorderRadius.circular(20),
              //                   ),
              //                   child: Text(
              //                     "Year ${yearData.year}",
              //                     style: const TextStyle(
              //                       color: Colors.deepPurple,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),

              //             const SizedBox(height: 14),

              //             /// ROUNDS
              //             ...yearData.rounds.map((round) {
              //               return Container(
              //                 margin: const EdgeInsets.only(bottom: 10),
              //                 padding: const EdgeInsets.symmetric(
              //                   horizontal: 14,
              //                   vertical: 12,
              //                 ),
              //                 decoration: BoxDecoration(
              //                   color: isDark
              //                       ? Colors.black.withOpacity(.25)
              //                       : Colors.grey.shade50,
              //                   borderRadius: BorderRadius.circular(12),
              //                 ),
              //                 child: Row(
              //                   mainAxisAlignment:
              //                       MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     /// ROUND LABEL
              //                     Row(
              //                       children: [
              //                         const Icon(
              //                           Icons.circle,
              //                           size: 10,
              //                           color: Colors.deepPurple,
              //                         ),
              //                         const SizedBox(width: 8),
              //                         Text(
              //                           "Round ${round.round}",
              //                           style: const TextStyle(
              //                             fontWeight: FontWeight.w600,
              //                           ),
              //                         ),
              //                       ],
              //                     ),

              //                     /// RANK BADGE
              //                     Container(
              //                       padding: const EdgeInsets.symmetric(
              //                         horizontal: 10,
              //                         vertical: 4,
              //                       ),
              //                       decoration: BoxDecoration(
              //                         color: Colors.blue.withOpacity(.12),
              //                         borderRadius: BorderRadius.circular(20),
              //                       ),
              //                       child: Text(
              //                         "Rank ${round.closingRank}",
              //                         style: const TextStyle(
              //                           color: Colors.blue,
              //                           fontWeight: FontWeight.bold,
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               );
              //             }),
              //           ],
              //         ),
              //       );
              //     }),
              //   ],
              // ),
              const SizedBox(height: 20),

              /// ---------------- CATEGORY CUTOFF ----------------
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// SECTION HEADER
                  Row(
                    children: const [
                      Icon(Icons.groups, color: Colors.teal),
                      SizedBox(width: 6),
                      Text(
                        "Category Cutoff",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// CATEGORY CARDS
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: data.categoryCutoff.map((cat) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 2 - 22,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xff1E1E1E)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(.05)
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// CATEGORY NAME
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                cat.category,
                                style: const TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            /// RANK
                            Row(
                              children: [
                                const Icon(
                                  Icons.emoji_events,
                                  size: 18,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 6),

                                Text(
                                  "Rank ${cat.closingRank}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            /// PROGRESS BAR
                            LinearProgressIndicator(
                              value: 0.6, // optional dynamic value
                              minHeight: 5,
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.teal,
                              backgroundColor: Colors.grey.withOpacity(.2),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// ---------------- AI ANALYSIS ----------------
              _card(
                isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.psychology, color: Colors.orange),
                        SizedBox(width: 6),
                        Text(
                          "AI Insight",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(data.analysis.message),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// CARD
  Widget _card(bool isDark, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          if (!isDark)
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
        ],
      ),
      child: child,
    );
  }

  /// RANK BOX
  Widget _rankBox(String title, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),

        const SizedBox(height: 4),

        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// TREND TILE
  Widget _trendTile(bool isDark, dynamic year, dynamic rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$year"),

          Row(
            children: [
              const Icon(Icons.trending_up, size: 18),
              const SizedBox(width: 6),
              Text("Rank $rank"),
            ],
          ),
        ],
      ),
    );
  }
}
