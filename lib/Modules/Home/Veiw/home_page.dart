import 'package:Gixa/Modules/Assistance/view/counselor_page.dart';
import 'package:Gixa/Modules/Chatbot/view/chatbot_view.dart';
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
import 'package:Gixa/common/widgets/primeum_dailog.dart';
import 'package:Gixa/naivgation/controller/nav_bar_controller.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/home_controller.dart';
import 'package:Gixa/Modules/ProfileProgress/veiw/profile_completion_card.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Get.put(HomeController());
  final MainNavController navController = Get.find();

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
      body: SafeArea(
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            navController.updateScroll(notification.direction);
            return false; // important
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
                  padding: const EdgeInsets.all(20),
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
                    borderRadius: BorderRadius.circular(12),
                    child: AbsorbPointer(
                      child: HomeSearchBar(
                        background: inputBg,
                        hintColor: textSecondary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // =========================
                // PRIMARY ACTION
                // =========================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kPrimaryBlue.withOpacity(isDark ? 0.9 : 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.auto_graph,
                          color: Colors.white,
                          size: 36,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'predict_colleges'.tr,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'get_colleges_based_on_rank'.tr,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              Get.toNamed(AppRoutes.compareCollage),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: Text('start'.tr),
                        ),
                      ],
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
                    onPredictorTap: () => Get.toNamed(AppRoutes.compareCollage),
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
                    children: const [
                      _InsightCard(
                        value: "12",
                        subtitleKey: 'colleges',
                        icon: Icons.school_outlined,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 12),
                      _InsightCard(
                        value: "5",
                        subtitleKey: 'favorites',
                        icon: Icons.bookmark_border,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 12),
                      _InsightCard(
                        value: "Strong",
                        subtitleKey: 'chance',
                        icon: Icons.trending_up,
                        color: Colors.green,
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

                const SizedBox(height: 16),

                SizedBox(
                  height: 280,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: const [
                      CollegeCard(
                        name: "IIT Bombay",
                        location: "Mumbai, India",
                        rank: "#3 NIRF",
                        imageUrl:
                            "https://images.unsplash.com/photo-1562774053-701939374585",
                      ),
                      CollegeCard(
                        name: "IIT Delhi",
                        location: "New Delhi, India",
                        rank: "#2 NIRF",
                        imageUrl:
                            "https://images.unsplash.com/photo-1562774053-701939374585",
                      ),
                    ],
                  ),
                ),

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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(title: "Daily News"),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  height: 170,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      return const NewsCard(
                        title: "NEET 2024 Counselling Update Released",
                        category: "Education",
                        time: "2h ago",
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // =========================
                // DAILY UPDATES
                // =========================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(title: "Daily Updates"),
                ),

                const SizedBox(height: 16),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      UpdateTile(
                        title: "NEET Registration Deadline Extended",
                        subtitle: "Students can now apply till March 5",
                      ),
                      SizedBox(height: 12),
                      UpdateTile(
                        title: "New Medical Colleges Approved",
                        subtitle: "5 new govt colleges approved for 2024",
                      ),
                      SizedBox(height: 12),
                      UpdateTile(
                        title: "AIIMS Exam Pattern Updated",
                        subtitle: "Minor changes in marking scheme",
                      ),
                    ],
                  ),
                ),

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
                //   child: SectionHeader(title: 'browse_state'.tr),
                // ),

                // const SizedBox(height: 16),

                // SizedBox(
                //   height: 110,
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     padding: const EdgeInsets.symmetric(horizontal: 20),
                //     children: const [
                //       CityAvatar(
                //         name: "MAHARASHTRA",
                //         imageUrl:
                //             "https://images.unsplash.com/photo-1587474260584-136574528ed5",
                //       ),
                //       CityAvatar(
                //         name: "KARNATAKA",
                //         imageUrl:
                //             "https://images.unsplash.com/photo-1570168007204-dfb528c6958f",
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
  final String value;
  final String subtitleKey;
  final IconData icon;
  final Color color;

  const _InsightCard({
    required this.value,
    required this.subtitleKey,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            Text(subtitleKey.tr, style: GoogleFonts.poppins(fontSize: 11)),
          ],
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
