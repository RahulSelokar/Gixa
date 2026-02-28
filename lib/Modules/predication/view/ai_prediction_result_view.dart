import 'package:Gixa/Modules/CollageDetails/controller/collage_detail_controller.dart';
import 'package:Gixa/Modules/CollageDetails/view/collage_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/predication_model.dart'; // Ensure this path is correct

class AiPredictionResultView extends StatefulWidget {
  final PredictionData predictionData;

  const AiPredictionResultView({super.key, required this.predictionData});

  @override
  State<AiPredictionResultView> createState() => _AiPredictionResultViewState();
}

class _AiPredictionResultViewState extends State<AiPredictionResultView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Modern Color Palette
  final Color primaryBrand = const Color(0xFF2563EB); // Royal Blue
  final Color successGreen = const Color(0xFF10B981); // Emerald
  final Color warningOrange = const Color(0xFFF59E0B); // Amber
  final Color dangerRed = const Color(0xFFEF4444); // Red
  final Color neutralGrey = const Color(0xFF64748B); // Slate

  final Color darkBg = const Color(0xFF0F172A); // Slate 900
  final Color lightBg = const Color(0xFFF1F5F9); // Slate 100
  final CollegeDetailController controller = Get.put(CollegeDetailController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? darkBg : lightBg;
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            _buildSliverAppBar(isDark),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                _buildTabBar(isDark, surfaceColor),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildCollegeList(
              widget.predictionData.safeColleges,
              successGreen,
              "High Chance",
              Icons.check_circle_outline_rounded,
              isDark,
            ),
            _buildCollegeList(
              widget.predictionData.moderateColleges,
              primaryBrand, // Blue for moderate
              "Medium Chance",
              Icons.remove_circle_outline_rounded,
              isDark,
            ),
            _buildCollegeList(
              widget.predictionData.ambitiousColleges,
              warningOrange,
              "Low Chance",
              Icons.trending_up_rounded,
              isDark,
            ),
            _buildCollegeList(
              widget.predictionData.noCutoffColleges,
              neutralGrey,
              "No Data / Other",
              Icons.help_outline_rounded,
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // APP BAR & HEADER
  // ==========================================================
  Widget _buildSliverAppBar(bool isDark) {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: isDark ? const Color(0xFF1E3A8A) : primaryBrand,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          "AI Prediction Results",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        background: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF1E3A8A), const Color(0xFF0F172A)]
                      : [const Color(0xFF2563EB), const Color(0xFF1D4ED8)],
                ),
              ),
            ),
            // Decorative circles
            Positioned(
              right: -30,
              top: -30,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white.withOpacity(0.1),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "AI Analysis Complete",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
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
    );
  }

  // ==========================================================
  // TAB BAR
  // ==========================================================
  TabBar _buildTabBar(bool isDark, Color surfaceColor) {
    final unselectedColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final selectedColor = isDark ? Colors.white : primaryBrand;

    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: selectedColor,
      unselectedLabelColor: unselectedColor,
      labelPadding: const EdgeInsets.symmetric(horizontal: 20),
      indicator: BoxDecoration(
        color: selectedColor.withOpacity(isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      tabs: const [
        Tab(text: "Safe"),
        Tab(text: "Moderate"),
        Tab(text: "Ambitious"),
        Tab(text: "Other"),
      ],
    );
  }

  // ==========================================================
  // COLLEGE LIST & CARDS
  // ==========================================================
  Widget _buildCollegeList(
    List<CollegeModel>? colleges,
    Color themeColor,
    String badgeText,
    IconData badgeIcon,
    bool isDark,
  ) {
    if (colleges == null || colleges.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
      itemCount: colleges.length,
      itemBuilder: (context, index) {
        final college = colleges[index];
        return _buildCollegeCard(
          college,
          themeColor,
          badgeText,
          badgeIcon,
          isDark,
        );
      },
    );
  }

  Widget _buildCollegeCard(
    CollegeModel college,
    Color themeColor,
    String badgeText,
    IconData badgeIcon,
    bool isDark,
  ) {
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final borderColor = isDark ? Colors.white10 : Colors.transparent;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            Get.to(
              () => CollegeDetailPage(),
              arguments: college.collegeId, // 👈 pass college id
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Logo + Name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          college.collegeName.isNotEmpty
                              ? college.collegeName[0]
                              : "U",
                          style: GoogleFonts.poppins(
                            color: themeColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            college.collegeName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: textColor,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: neutralGrey,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "${college.city}, ${college.state}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: neutralGrey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark ? Colors.white10 : Colors.grey.shade100,
                ),
                const SizedBox(height: 12),

                // Bottom Row: Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusBadge(badgeText, badgeIcon, themeColor, isDark),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Last Year Cutoff",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: neutralGrey,
                          ),
                        ),
                        Text(
                          "#${college.cutoffAirLast ?? 'N/A'}",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(
    String text,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // EMPTY STATE
  // ==========================================================
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No colleges found",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your filters or category\nto see more results.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// STICKY HEADER DELEGATE
// ==========================================================
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF1F5F9), // Match scaffold bg
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
