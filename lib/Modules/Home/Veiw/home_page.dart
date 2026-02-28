import 'package:Gixa/Modules/Assistance/view/counselor_page.dart';
import 'package:Gixa/Modules/Chatbot/view/chatbot_view.dart';
import 'package:Gixa/Modules/Collage/controller/collage_list_controller.dart';
import 'package:Gixa/Modules/Collage/veiw/collage_list_page.dart';
import 'package:Gixa/Modules/Home/widgets/category_list.dart';
import 'package:Gixa/Modules/Home/widgets/city_avatar.dart';
import 'package:Gixa/Modules/Home/widgets/college_card.dart';
import 'package:Gixa/Modules/Home/widgets/counselling_banner.dart';
import 'package:Gixa/Modules/Home/widgets/news_card.dart';
import 'package:Gixa/Modules/Home/widgets/update_tile.dart';
import 'package:Gixa/Modules/Home/widgets/home_header.dart';
import 'package:Gixa/Modules/Home/widgets/search_bar.dart';
import 'package:Gixa/Modules/Home/widgets/section_header.dart';
import 'package:Gixa/Modules/Home/widgets/stream_card.dart';
import 'package:Gixa/Modules/comparison/view/compare_colleges_page.dart';
import 'package:Gixa/Modules/favourite/model/fevorite_model.dart';
import 'package:Gixa/Modules/favourite/view/favourite_colleges_page.dart';
import 'package:Gixa/Modules/predication/view/predication_view.dart';
import 'package:Gixa/common/widgets/primeum_dailog.dart';
import 'package:Gixa/naivgation/controller/nav_bar_controller.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/home_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Get.put(HomeController());
  final MainNavController navController = Get.find();
  final CollegeListController collegeListController =
      Get.find<CollegeListController>();

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

    return Scaffold(
      backgroundColor: bg,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton(
          onPressed: () {
            Get.toNamed('/chat-bot');
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
            return true; // Stop bubbling
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================
                // HEADER
                // =========================
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: HomeHeader(
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    borderColor: border,
                  ),
                ),

                // =========================
                // SEARCH
                // =========================
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

                // =========================
                // PRIMARY ACTION
                // =========================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Get.to(() => PredictionView());
                      },
                      child: Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              kPrimaryBlue,
                              kPrimaryBlue.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryBlue.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -20,
                              bottom: -20,
                              child: Icon(
                                Icons.auto_graph_rounded,
                                size: 120,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),

                            /// Hero Image
                            Positioned(
                              right: 10,
                              top: -10,
                              bottom: -10,
                              child: Hero(
                                tag: 'predict_hero',
                                child: Image.network(
                                  'https://cdn3d.iconscout.com/3d/premium/thumb/rocket-4993641-4160494.png',
                                  height: 140,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.rocket_launch_rounded,
                                      size: 80,
                                      color: Colors.white.withOpacity(0.9),
                                    );
                                  },
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'predict_colleges'.tr,
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                      'get_colleges_based_on_rank'.tr,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
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

                const SizedBox(height: 24),

                // =========================
                // CATEGORY LIST
                // =========================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CategoryList(
                    isDark: isDark,
                    surface: surface,
                    border: border,
                    onCollegesTap: () => Get.to(() => CollegeListPage()),
                    onPredictorTap: () => Get.toNamed(AppRoutes.prediction),
                    onCutoffTap: () => Get.dialog(const PremiumLockDialog()),
                    onHelpTap: () => Get.toNamed('/chat-bot'),
                    onAssistanceTap: () {
                      Get.to(() => CounselorListView(requestId: "REQ_101"));
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // =========================
                // INSIGHTS
                // =========================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _InsightCard(
                        subtitleKey: 'Compare',
                        imageUrl:
                            "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/School/3D/school_3d.png",
                        color: Colors.blue,
                        onTap: () {
                          Get.to(() => CompareCollegesView());
                        },
                      ),

                      const SizedBox(width: 12),

                      _InsightCard(
                        subtitleKey: 'favorites',
                        imageUrl:
                            "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Star/3D/star_3d.png",
                        color: Colors.orange,
                        onTap: () {
                          Get.to(() => FavouriteCollegesPage());
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // =========================
                // PROFILE COMPLETION
                // =========================
                // const ProfileCompletionSlider(),
                const SizedBox(height: 30),

                // =========================
                // FEATURED COLLEGES
                // =========================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'featured_colleges'.tr,
                    onSeeAll: () => Get.to(() => CollegeListPage()),
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
                const SizedBox(height: 30),

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
class _InsightCard extends StatelessWidget {
  final String subtitleKey;
  final String imageUrl;
  final Color color;
  final VoidCallback? onTap;

  const _InsightCard({
    required this.subtitleKey,
    required this.imageUrl,
    required this.color,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(isDark ? 0.25 : 0.12),
                    color.withOpacity(isDark ? 0.08 : 0.04),
                  ],
                ),
                border: Border.all(
                  color: color.withOpacity(isDark ? 0.35 : 0.18),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  /// Floating Icon
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Opacity(
                      opacity: 0.85,
                      child: Image.network(
                        imageUrl,
                        height: width * 0.10, // Responsive icon size
                        width: width * 0.10,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  ),

                  /// Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        subtitleKey.tr,
                        style: GoogleFonts.poppins(
                          fontSize: width * 0.035, // Responsive font
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ],
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
          style: GoogleFonts.poppins(
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
        style: GoogleFonts.poppins(
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
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.055,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Explore colleges, predict rank chances & counselling roadmap",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
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
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
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
          style: GoogleFonts.poppins(fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
