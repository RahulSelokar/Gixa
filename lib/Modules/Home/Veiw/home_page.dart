import 'package:Gixa/Modules/Assistance/view/counselor_page.dart';
import 'package:Gixa/Modules/Chatbot/view/chatbot_view.dart';
import 'package:Gixa/Modules/Collage/controller/collage_list_controller.dart';
import 'package:Gixa/Modules/Collage/veiw/collage_list_page.dart';
import 'package:Gixa/Modules/Faq/controller/faq_controller.dart';
import 'package:Gixa/Modules/Home/widgets/category_list.dart';
import 'package:Gixa/Modules/Home/widgets/city_avatar.dart';
import 'package:Gixa/Modules/Home/widgets/college_card.dart';
import 'package:Gixa/Modules/Home/widgets/counselling_banner.dart';
import 'package:Gixa/Modules/Home/widgets/news_card.dart';
import 'package:Gixa/Modules/Home/widgets/prediction_banner.dart';
import 'package:Gixa/Modules/Home/widgets/update_tile.dart';
import 'package:Gixa/Modules/Home/widgets/home_header.dart';
import 'package:Gixa/Modules/Home/widgets/search_bar.dart';
import 'package:Gixa/Modules/Home/widgets/section_header.dart';
import 'package:Gixa/Modules/Home/widgets/stream_card.dart';
import 'package:Gixa/Modules/ProfileProgress/veiw/profile_completion_card.dart';
import 'package:Gixa/Modules/comparison/view/compare_colleges_page.dart';
import 'package:Gixa/Modules/cutoff/view/cutoff_graph.dart';
import 'package:Gixa/Modules/favourite/model/fevorite_model.dart';
import 'package:Gixa/Modules/favourite/view/favourite_colleges_page.dart';
import 'package:Gixa/Modules/predication/controller/prediction_controller.dart';
import 'package:Gixa/Modules/predication/model/predication_model.dart';
import 'package:Gixa/Modules/predication/view/ai_prediction_result_view.dart';
import 'package:Gixa/Modules/predication/view/predication_view.dart';
import 'package:Gixa/common/widgets/primeum_dailog.dart';
import 'package:Gixa/naivgation/controller/nav_bar_controller.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/services/auth_guard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/home_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Get.find<HomeController>();
  final MainNavController navController = Get.find();
  final CollegeListController collegeListController =
      Get.isRegistered<CollegeListController>()
      ? Get.find<CollegeListController>()
      : Get.put(CollegeListController(), permanent: true);
  final FaqController faqController = Get.put(FaqController());

  final Color kPrimaryBlue = const Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF121212) : Colors.white;
    final surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final inputBg = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF5F5F5);
    final textPrimary = isDark ? Colors.white : Colors.black;
    final textSecondary = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final border = isDark ? Colors.grey[800]! : Colors.grey[200]!;

    final predictionController = Get.put(PredictionController());

    return Scaffold(
      backgroundColor: bg,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton(
          onPressed: () {
            // AuthGuard.checkAccess(() {
            //   Get.toNamed('/chat-bot');
            // });
            AuthGuard.checkAccess(
              onAllowed: () {
                Get.toNamed('/chat-bot');
              },
            );
          },
          backgroundColor: const Color(0xFF1565C0),
          elevation: 6,
          child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            navController.updateScroll(notification.direction);
            return true;
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: HomeHeader(
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    borderColor: border,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () => Get.toNamed(AppRoutes.search),
                    borderRadius: BorderRadius.circular(16),
                    child: AbsorbPointer(
                      child: HomeSearchBar(
                        background: inputBg,
                        hintColor: textSecondary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const ProfileCompletionSlider(),
                const SizedBox(height: 10),

                // In your home screen — replace the old Padding(…) block with:
                PredictionBanner(
                  onTap: () {
                    AuthGuard.checkAccess(
                      onAllowed: () {
                        if (controller.canAccessPrediction()) {
                          Get.toNamed(AppRoutes.prediction);
                        } else {
                          Get.dialog(const PremiumLockDialog());
                        }
                      },
                    );
                  },
                ),

                // Show recent predictions as a horizontal row below categories
                Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 0),
                  child: Obx(() {
                    final recent = predictionController.recentPredictions;
                    if (recent.isEmpty) return const SizedBox();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Recent Predictions',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textPrimary.withOpacity(0.85),
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 70,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: recent.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 10),
                            itemBuilder: (context, idx) {
                              final p = recent[idx];
                              final cardColor = isDark
                                  ? Colors.white.withOpacity(0.04)
                                  : Colors.grey[100];
                              final borderColor = isDark
                                  ? Colors.white.withOpacity(0.10)
                                  : Colors.grey[300];
                              return InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {
                                  final predictionData =
                                      PredictionData.fromApiResponse(p);
                                  Get.to(
                                    () => AiPredictionResultView(
                                      predictionData: predictionData,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 220,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: borderColor!),
                                    boxShadow: [
                                      if (!isDark)
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.analytics_outlined,
                                        size: 22,
                                        color: isDark
                                            ? Colors.blue[200]
                                            : kPrimaryBlue,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${p['state']} | ${p['category']} | ${p['course']}',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: textPrimary.withOpacity(
                                                  0.92,
                                                ),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Year: ${p['year']}  AIR: ${p['rank']}  Quota: ${p['quota']}',
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                color: textSecondary
                                                    .withOpacity(0.85),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color: textSecondary.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                ),

                // =========================
                // PRIMARY ACTION
                // =========================
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: Material(
                //     color: Colors.transparent,
                //     borderRadius: BorderRadius.circular(24),
                //     child: InkWell(
                //       borderRadius: BorderRadius.circular(24),
                //       splashColor: Colors.white.withOpacity(0.08),
                //       highlightColor: Colors.white.withOpacity(0.04),
                //       onTap: () {
                //         Get.toNamed(AppRoutes.prediction);
                //       },
                //       child: Container(
                //         width: double.infinity,
                //         height: 130,
                //         decoration: BoxDecoration(
                //           gradient: const LinearGradient(
                //             colors: [
                //               Color(0xFF1A56DB), // richer blue start
                //               Color(0xFF1044B2), // deeper end
                //             ],
                //             begin: Alignment.topLeft,
                //             end: Alignment.bottomRight,
                //           ),
                //           borderRadius: BorderRadius.circular(24),
                //           boxShadow: [
                //             BoxShadow(
                //               color: const Color(0xFF1A56DB).withOpacity(0.38),
                //               blurRadius: 20,
                //               spreadRadius: -4,
                //               offset: const Offset(0, 10),
                //             ),
                //             // subtle inner-top highlight
                //             BoxShadow(
                //               color: Colors.white.withOpacity(0.06),
                //               blurRadius: 1,
                //               spreadRadius: 0,
                //               offset: const Offset(0, 1),
                //             ),
                //           ],
                //         ),
                //         child: Stack(
                //           clipBehavior: Clip.hardEdge,
                //           children: [
                //             // ── decorative circles ──────────────────────────────
                //             Positioned(
                //               right: -30,
                //               top: -30,
                //               child: Container(
                //                 width: 120,
                //                 height: 120,
                //                 decoration: BoxDecoration(
                //                   shape: BoxShape.circle,
                //                   color: Colors.white.withOpacity(0.05),
                //                 ),
                //               ),
                //             ),
                //             Positioned(
                //               right: 60,
                //               bottom: -40,
                //               child: Container(
                //                 width: 90,
                //                 height: 90,
                //                 decoration: BoxDecoration(
                //                   shape: BoxShape.circle,
                //                   color: Colors.white.withOpacity(0.05),
                //                 ),
                //               ),
                //             ),

                //             // ── left content ────────────────────────────────────
                //             Positioned.fill(
                //               child: Padding(
                //                 padding: const EdgeInsets.fromLTRB(
                //                   20,
                //                   0,
                //                   130,
                //                   0,
                //                 ),
                //                 child: Column(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     // badge chip
                //                     Container(
                //                       padding: const EdgeInsets.symmetric(
                //                         horizontal: 8,
                //                         vertical: 3,
                //                       ),
                //                       decoration: BoxDecoration(
                //                         color: Colors.white.withOpacity(0.15),
                //                         borderRadius: BorderRadius.circular(20),
                //                         border: Border.all(
                //                           color: Colors.white.withOpacity(0.2),
                //                           width: 0.8,
                //                         ),
                //                       ),
                //                       child: Text(
                //                         'AI Powered',
                //                         style: GoogleFonts.inter(
                //                           fontSize: 9,
                //                           fontWeight: FontWeight.w600,
                //                           color: Colors.white.withOpacity(0.9),
                //                           letterSpacing: 0.6,
                //                         ),
                //                       ),
                //                     ),

                //                     const SizedBox(height: 6),

                //                     // headline
                //                     Text(
                //                       'College\nPredictor',
                //                       style: GoogleFonts.inter(
                //                         fontSize: 16,
                //                         fontWeight: FontWeight.w700,
                //                         color: Colors.white,
                //                         height: 1.15,
                //                         letterSpacing: -0.3,
                //                       ),
                //                     ),

                //                     const SizedBox(height: 6),

                //                     // sub-label
                //                     Text(
                //                       'Find your best-fit colleges →',
                //                       style: GoogleFonts.inter(
                //                         fontSize: 11,
                //                         fontWeight: FontWeight.w400,
                //                         color: Colors.white.withOpacity(0.72),
                //                         letterSpacing: 0.1,
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ),

                //             // ── hero image ──────────────────────────────────────
                //             Positioned(
                //               right: 0,
                //               top: -8,
                //               bottom: -8,
                //               child: Hero(
                //                 tag: 'predict_hero',
                //                 child: Image.network(
                //                   'https://cdn3d.iconscout.com/3d/premium/thumb/rocket-4993641-4160494.png',
                //                   width: 128,
                //                   fit: BoxFit.contain,
                //                   errorBuilder: (_, __, ___) => Padding(
                //                     padding: const EdgeInsets.all(20),
                //                     child: Icon(
                //                       Icons.rocket_launch_rounded,
                //                       size: 72,
                //                       color: Colors.white.withOpacity(0.9),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // =========================
                // CATEGORY LIST
                // =========================
                Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: CategoryList(
                    isDark: isDark,
                    surface: surface,
                    border: border,
                    onCollegesTap: () {
                      AuthGuard.checkAccess(
                        onAllowed: () {
                          if (controller.canAccessCollegeList()) {
                            Get.to(() => CollegeListPage());
                          } else {
                            Get.dialog(const PremiumLockDialog());
                          }
                        },
                      );
                    },
                    onPredictorTap: () {
                      AuthGuard.checkAccess(
                        onAllowed: () {
                          if (controller.canAccessPrediction()) {
                            Get.to(() => const PredictionView());
                          } else {
                            Get.dialog(const PremiumLockDialog());
                          }
                        },
                      );
                    },

                    onCutoffTap: () {
                      AuthGuard.checkAccess(
                        onAllowed: () {
                          if (controller.canAccessCutoff()) {
                            Get.to(() => const AirComparisonGraphPage());
                          } else {
                            Get.dialog(const PremiumLockDialog());
                          }
                        },
                      );
                    },
                    onHelpTap: () => Get.toNamed('/chat-bot'),
                    onAssistanceTap: () {
                      // Get.to(() => CounselorListView(requestId: "REQ_101"));
                      AuthGuard.checkAccess(
                        onAllowed: () {
                          if (controller.canAccessCounsellingSteps()) {
                            Get.to(() =>  CounselorListView( requestId: "REQ_101"));
                          } else {
                            Get.dialog(const PremiumLockDialog());
                          }
                        },
                      );
                    },
                    onApplicationsTap: () =>
                        Get.dialog(const PremiumLockDialog()),
                  ),
                ),

                // const SizedBox(height: 24),

                // =========================
                // INSIGHTS
                // =========================
                // Row(
                //   children: [
                //     InsightCard(
                //       subtitleKey: 'Top Colleges',
                //       imageUrl: 'https://...',
                //       color: const Color(0xFF1A56DB),
                //       onTap: () => Get.toNamed(AppRoutes.collage),
                //     ),
                //     InsightCard(
                //       subtitleKey: 'Favourite Colleges',
                //       imageUrl: 'https://...',
                //       color: const Color(0xFF0D9E75),
                //       onTap: () => Get.toNamed(AppRoutes.fevouriteCollage),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 6),

                // =========================
                // PROFILE COMPLETION
                // =========================
                // const SizedBox(height: 30),

                // =========================
                // FEATURED COLLEGES
                // =========================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'featured_colleges'.tr,
                    // onSeeAll: () => Get.to(() => CollegeListPage()),
                  ),
                ),

                // const SizedBox(height: 16),
                Obx(() {
                  final colleges = collegeListController.colleges;

                  if (colleges.isEmpty) {
                    return SizedBox();
                  }

                  final topTwo = colleges.take(2).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 20),

                      /// 🔥 Section Title
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16),
                      //   child: Text(
                      //     "Recommended Colleges",
                      //     style: TextStyle(
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 16),

                      /// 🔥 Horizontal Cards
                      SizedBox(
                        height: 320,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 16),
                          itemCount: topTwo.length,
                          itemBuilder: (context, index) {
                            final college = topTwo[index];

                            return CollegeCard(
                              id: college.id,
                              name: college.name,
                              location: college.state.name,
                              // rank: "AIR ${college. ?? '--'}",
                              imageUrl: college.displayImage ?? "",
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 30),

                // =========================
                // STREAMS
                // =========================
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: SectionHeader(title: 'explore_stream'.tr),
                // ),

                // const SizedBox(height: 16),

                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: Row(
                //     children: const [
                //       StreamCard(
                //         title: "UG",
                //         icon: Icons.school_outlined,
                //         color: Colors.blue,
                //       ),
                //       SizedBox(width: 12),
                //       StreamCard(
                //         title: "PG",
                //         icon: Icons.workspace_premium_outlined,
                //         color: Colors.green,
                //       ),
                //       SizedBox(width: 12),
                //       StreamCard(
                //         title: "Other",
                //         icon: Icons.auto_awesome_outlined,
                //         color: Colors.orange,
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 30),

                // DAILY NEWS
                // =========================
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: SectionHeader(title: "Daily News"),
                // ),

                // const SizedBox(height: 16),

                // SizedBox(
                //   height: 170,
                //   child: ListView.separated(
                //     scrollDirection: Axis.horizontal,
                //     padding: const EdgeInsets.symmetric(horizontal: 20),
                //     itemCount: 5,
                //     separatorBuilder: (_, __) => const SizedBox(width: 14),
                //     itemBuilder: (context, index) {
                //       final images = [
                //         "https://images.unsplash.com/photo-1523050854058-8df90110c9f1?q=80&w=600&auto=format&fit=crop",
                //         "https://images.unsplash.com/photo-1532094349884-543bc11b234d?q=80&w=600&auto=format&fit=crop",
                //         "https://images.unsplash.com/photo-1576091160550-2173dba999ef?q=80&w=600&auto=format&fit=crop",
                //       ];

                //       return NewsCard(
                //         title: "NEET 2024 Counselling Update Released",
                //         category: "Education",
                //         time: "2h ago",
                //         imageUrl: images[index % images.length],
                //       );
                //     },
                //   ),
                // ),

                // const SizedBox(height: 30),

                // // =========================
                // // DAILY UPDATES
                // // =========================
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: SectionHeader(title: "Daily Updates"),
                // ),

                // const SizedBox(height: 16),

                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 20),
                //   child: Column(
                //     children: const [
                //       UpdateTile(
                //         title: "NEET Registration Deadline Extended",
                //         subtitle: "Students can now apply till March 5",
                //         imageUrl:
                //             "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?q=80&w=200&auto=format&fit=crop",
                //       ),
                //       SizedBox(height: 12),
                //       UpdateTile(
                //         title: "New Medical Colleges Approved",
                //         subtitle: "5 new govt colleges approved for 2024",
                //         imageUrl:
                //             "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=200&auto=format&fit=crop",
                //       ),
                //       SizedBox(height: 12),
                //       UpdateTile(
                //         title: "AIIMS Exam Pattern Updated",
                //         subtitle: "Minor changes in marking scheme",
                //         imageUrl:
                //             "https://images.unsplash.com/photo-1606326608606-aa0b62935f2b?q=80&w=200&auto=format&fit=crop",
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 30),

                const CounsellingBanner(),
                const SizedBox(height: 30),

                /// =========================
                /// FAQ SECTION
                /// =========================
                Obx(() {
                  if (faqController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (faqController.faqList.isEmpty) {
                    return const SizedBox();
                  }

                  final faqs = faqController.displayedFaqs;
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// HEADER
                        Row(
                          children: [
                            const Icon(
                              Icons.help_outline,
                              color: Color(0xFF1565C0),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "FAQs",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// FAQ LIST
                        ...faqs.map((faq) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E1E1E)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withOpacity(.05)
                                    : Colors.grey.shade200,
                              ),
                              boxShadow: [
                                if (!isDark)
                                  const BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                              ],
                            ),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              childrenPadding: const EdgeInsets.fromLTRB(
                                16,
                                0,
                                16,
                                16,
                              ),

                              iconColor: const Color(0xFF1565C0),
                              collapsedIconColor: Colors.grey,

                              title: Row(
                                children: [
                                  const Icon(
                                    Icons.question_answer,
                                    size: 18,
                                    color: Color(0xFF1565C0),
                                  ),
                                  const SizedBox(width: 8),

                                  Expanded(
                                    child: Text(
                                      faq.question,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.black.withOpacity(.2)
                                        : const Color(0xFFF5F7FB),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    faq.answer,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 6),

                        /// SHOW MORE BUTTON
                        if (faqController.faqList.length > 3)
                          Center(
                            child: TextButton(
                              onPressed: faqController.toggleFaqs,
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF1565C0),
                              ),
                              child: Text(
                                faqController.showAllFaqs.value
                                    ? "Show Less"
                                    : "View All FAQs",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 30),

                // =========================
                // NEET HERO SECTION
                // =========================
                NeetHeroSection(
                  isDark: isDark,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                // const SizedBox(height: 30),

                // =========================
                // STATES
                // =========================
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: SectionHeader(
                //     title: 'browse_state'.tr,
                //     onSeeAll: () {},
                //   ),
                // ),

                // const SizedBox(height: 16),

                // SizedBox(
                //   height: 160,
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     padding: const EdgeInsets.symmetric(horizontal: 20),
                //     children: [
                //       _StateCard(
                //         name: "MAHARASHTRA",
                //         imageUrl:
                //             "https://images.unsplash.com/photo-1587474260584-136574528ed5?q=80&w=600&auto=format&fit=crop",
                //       ),
                //       const SizedBox(width: 16),
                //       _StateCard(
                //         name: "KARNATAKA",
                //         imageUrl:
                //             "https://images.unsplash.com/photo-1570168007204-dfb528c6958f?q=80&w=600&auto=format&fit=crop",
                //       ),
                //       const SizedBox(width: 16),
                //       _StateCard(
                //         name: "DELHI",
                //         imageUrl:
                //             "https://images.unsplash.com/photo-1587474260584-136574528ed5?q=80&w=600&auto=format&fit=crop",
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =========================
// INSIGHT CARD
// =========================

class InsightCard extends StatefulWidget {
  final String subtitleKey;
  final String imageUrl;
  final Color color;
  final VoidCallback? onTap;

  const InsightCard({
    required this.subtitleKey,
    required this.imageUrl,
    required this.color,
    this.onTap,
    super.key,
  });

  @override
  State<InsightCard> createState() => _InsightCardState();
}

class _InsightCardState extends State<InsightCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _glowAnim;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _glowAnim = Tween<double>(
      begin: 1.0,
      end: 0.4,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    HapticFeedback.lightImpact();
    setState(() => _isPressed = true);
    _ctrl.forward();
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    _ctrl.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final color = widget.color;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) =>
                Transform.scale(scale: _scaleAnim.value, child: child),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: isDark
                    ? Color.lerp(
                        const Color(0xFF1A1A2E),
                        color.withOpacity(0.18),
                        0.9,
                      )
                    : Colors.white,
                border: Border.all(
                  color: _isPressed
                      ? color.withOpacity(0.55)
                      : color.withOpacity(isDark ? 0.28 : 0.18),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(
                      _isPressed ? 0.08 : (isDark ? 0.22 : 0.14),
                    ),
                    blurRadius: _isPressed ? 8 : 20,
                    spreadRadius: -2,
                    offset: Offset(0, _isPressed ? 2 : 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  children: [
                    // ── soft tinted background wash ──────────────
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              color.withOpacity(isDark ? 0.14 : 0.07),
                              color.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── large blurred circle accent (bottom-right) ─
                    Positioned(
                      right: -18,
                      bottom: -18,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withOpacity(isDark ? 0.12 : 0.10),
                        ),
                      ),
                    ),

                    // ── content ───────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ── icon bubble ──────────────────────────
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: color.withOpacity(isDark ? 0.20 : 0.12),
                              border: Border.all(
                                color: color.withOpacity(isDark ? 0.30 : 0.15),
                                width: 1.0,
                              ),
                            ),
                            child: Image.network(
                              widget.imageUrl,
                              height: width * 0.07,
                              width: width * 0.07,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.auto_awesome_rounded,
                                color: color,
                                size: width * 0.065,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ── title ────────────────────────────────
                          Text(
                            widget.subtitleKey.tr,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A1A2E),
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // ── "Explore now" pill ───────────────────
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: color.withOpacity(isDark ? 0.20 : 0.10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Explore',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 12,
                                  color: color,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const _StateCard({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
          ),
        ),
        padding: const EdgeInsets.all(12),
        alignment: Alignment.bottomLeft,
        child: Text(
          name,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final String label;

  const _HeroChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1565C0),
        ),
      ),
    );
  }
}

class NeetHeroSection extends StatelessWidget {
  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;

  const NeetHeroSection({
    super.key,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [
      //       const Color(0xFF1565C0).withOpacity(0.06),
      //       Colors.transparent,
      //     ],
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomCenter,
      //   ),
      // ),
      decoration: BoxDecoration(
        color: scaffoldBg,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),

      child: Column(
        children: [
          /// 🔹 Heading
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  "Plan Your NEET UG Journey",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: width * 0.055,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Explore colleges, predict rank chances & counselling roadmap",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: width * 0.032,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          /// 🔹 Doctor Illustration Section
          SizedBox(
            height: 320,
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// Soft Circle Background
                Container(
                  width: width * 0.55,
                  height: width * 0.55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1565C0).withOpacity(0.08),
                  ),
                ),

                /// SVG Doctor
                SvgPicture.asset(
                  "assets/images/doctors.svg",
                  height: 260,
                  fit: BoxFit.contain,
                ),

                /// Floating Chips
                Positioned(top: 20, left: 20, child: _HeroChip(label: "MBBS")),
                Positioned(top: 50, right: 10, child: _HeroChip(label: "BDS")),
                Positioned(
                  bottom: 70,
                  left: 10,
                  child: _HeroChip(label: "AIQ"),
                ),
                Positioned(
                  bottom: 40,
                  right: 20,
                  child: _HeroChip(label: "State Quota"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          /// 🔹 Features Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _HeroFeature(icon: Icons.school_outlined, label: "Explore"),
                _HeroFeature(icon: Icons.analytics_outlined, label: "Predict"),
                _HeroFeature(icon: Icons.menu_book_outlined, label: "Guide"),
              ],
            ),
          ),

          const SizedBox(height: 25),

          /// 🔹 CTA Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.compareCollage);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Get Started",
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroFeature extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroFeature({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: const Color(0xFF1565C0)),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
