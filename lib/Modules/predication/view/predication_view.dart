// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import '../controller/prediction_controller.dart';
// import '../model/predication_model.dart';

// class PredictionView extends StatefulWidget {
//   const PredictionView({super.key});

//   @override
//   State<PredictionView> createState() => _PredictionViewState();
// }

// class _PredictionViewState extends State<PredictionView>
//     with SingleTickerProviderStateMixin {
//   final PredictionController controller = Get.put(PredictionController());
//   late TabController _tabController;

//   // 🔹 PROFESSIONAL BLUE PALETTE
//   final Color primaryBlue = const Color(0xFF2563EB); // Royal Blue
//   final Color accentBlue = const Color(0xFF3B82F6); // Bright Blue
//   final Color lightBlueBg = const Color(0xFFEFF6FF); // Very Light Blue
//   final Color darkBg = const Color(0xFF0F172A); // Slate 900
  
//   // Status Colors
//   final Color successGreen = const Color(0xFF059669);
//   final Color warningOrange = const Color(0xFFD97706);
//   final Color neutralGrey = const Color(0xFF64748B);

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final bgColor = isDark ? darkBg : Colors.white;
//     final textColor = isDark ? Colors.white : const Color(0xFF1E293B);

//     return Scaffold(
//       backgroundColor: bgColor,
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               _buildHeader(isDark),
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: bgColor,
//                     borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
//                   ),
//                   child: Obx(() {
//                     if (!controller.hasResult.value) {
//                       return _buildInputForm(isDark, textColor);
//                     } else {
//                       return _buildResultSection(isDark, textColor);
//                     }
//                   }),
//                 ),
//               ),
//             ],
//           ),

//           /// 🔹 AI Loading Overlay
//           Obx(() {
//             if (controller.isPredictionLoading.value) {
//               return _buildAiOverlay(isDark);
//             }
//             return const SizedBox();
//           }),
//         ],
//       ),
//     );
//   }

//   // ==========================================================
//   // 🎨 MODERN HEADER WITH DEPTH
//   // ==========================================================
//   Widget _buildHeader(bool isDark) {
//     return Container(
//       width: double.infinity,
//       height: 200, // Fixed height for header area
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: isDark 
//             ? [const Color(0xFF1E3A8A), const Color(0xFF172554)] 
//             : [primaryBlue, const Color(0xFF1D4ED8)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Stack(
//         children: [
//           // Decorative Circles
//           Positioned(
//             top: -50,
//             right: -50,
//             child: Container(
//               width: 200,
//               height: 200,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.05),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 20,
//             left: -30,
//             child: Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.05),
//               ),
//             ),
//           ),
          
//           // Content
//           Padding(
//             padding: const EdgeInsets.fromLTRB(24, 70, 24, 0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: Colors.white.withOpacity(0.1)),
//                       ),
//                       child: Row(
//                         children: const [
//                           Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 14),
//                           SizedBox(width: 6),
//                           Text(
//                             "AI Powered",
//                             style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "College Predictor",
//                       style: TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.white,
//                         letterSpacing: -0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: Colors.white.withOpacity(0.2)),
//                   ),
//                   child: const Icon(Icons.school_rounded, color: Colors.white, size: 28),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================================================
//   // 📝 INPUT FORM
//   // ==========================================================
//   Widget _buildInputForm(bool isDark, Color textColor) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
//       physics: const BouncingScrollPhysics(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// AIR High-Emphasis Card
//           Obx(() => Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: isDark 
//                   ? [const Color(0xFF334155), const Color(0xFF1E293B)] 
//                   : [const Color(0xFF3B82F6), const Color(0xFF2563EB)], // Solid Blue Gradient
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: [
//                 BoxShadow(
//                   color: primaryBlue.withOpacity(0.3),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Your All India Rank",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.white.withOpacity(0.8),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       "#${controller.userAir.value}",
//                       style: const TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.w900,
//                         color: Colors.white,
//                         letterSpacing: -1,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 32),
//                 ),
//               ],
//             ),
//           )),

//           const SizedBox(height: 32),
//           Text(
//             "Filter Criteria",
//             style: TextStyle(
//               fontSize: 18, 
//               fontWeight: FontWeight.w700, 
//               color: textColor,
//               letterSpacing: -0.5
//             ),
//           ),
//           const SizedBox(height: 20),

//           _buildModernDropdown(
//             label: "State Preference",
//             hint: "Select State",
//             icon: Icons.map_rounded,
//             items: ["Maharashtra", "Delhi", "Karnataka"],
//             onChanged: (v) => controller.selectedState.value = v ?? "",
//             isDark: isDark,
//           ),
//           const SizedBox(height: 16),

//           Row(
//             children: [
//               Expanded(
//                 child: _buildModernDropdown(
//                   label: "Category",
//                   hint: "Select",
//                   icon: Icons.category_rounded,
//                   items: ["GEN", "OBC", "SC", "ST"],
//                   onChanged: (v) => controller.selectedCategory.value = v ?? "",
//                   isDark: isDark,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildModernDropdown(
//                   label: "Year",
//                   hint: "Select",
//                   icon: Icons.calendar_month_rounded,
//                   items: ["2024", "2023", "2022"],
//                   onChanged: (v) =>
//                       controller.selectedYear.value = int.tryParse(v ?? ""),
//                   isDark: isDark,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           _buildModernDropdown(
//             label: "Desired Course",
//             hint: "Select Course",
//             icon: Icons.school_rounded,
//             items: ["B.Tech", "MBBS", "BDS"],
//             onChanged: (v) => controller.selectedCourse.value = v ?? "",
//             isDark: isDark,
//           ),

//           const SizedBox(height: 40),

//           /// Generate Button
//           SizedBox(
//             width: double.infinity,
//             height: 58,
//             child: ElevatedButton(
//               onPressed: controller.fetchPrediction,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryBlue,
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//                 shadowColor: Colors.transparent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(18),
//                 ),
//               ),
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Predict My Colleges",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(width: 8),
//                   Icon(Icons.arrow_forward_rounded, size: 20),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildModernDropdown({
//     required String label,
//     required String hint,
//     required IconData icon,
//     required List<String> items,
//     required Function(String?) onChanged,
//     required bool isDark,
//   }) {
//     final bgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9); // Light Grey/Blue tint
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//             color: isDark ? Colors.white60 : const Color(0xFF64748B),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//           decoration: BoxDecoration(
//             color: bgColor,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: isDark ? Colors.transparent : Colors.grey.shade200,
//             ),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               isExpanded: true,
//               icon: Icon(Icons.keyboard_arrow_down_rounded,
//                   color: isDark ? Colors.white70 : Colors.black45),
//               hint: Row(
//                 children: [
//                   Icon(icon, size: 20, color: accentBlue),
//                   const SizedBox(width: 12),
//                   Text(hint, style: TextStyle(fontSize: 14, color: isDark ? Colors.white54 : Colors.black45)),
//                 ],
//               ),
//               items: items
//                   .map((e) => DropdownMenuItem(
//                       value: e,
//                       child: Text(e,
//                           style: TextStyle(
//                               color: isDark ? Colors.white : const Color(0xFF1E293B), fontWeight: FontWeight.w500))))
//                   .toList(),
//               onChanged: onChanged,
//               dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
//               borderRadius: BorderRadius.circular(16),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ==========================================================
//   // 📊 RESULTS SECTION
//   // ==========================================================
//   Widget _buildResultSection(bool isDark, Color textColor) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Prediction Results",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.w800,
//                   color: textColor,
//                   letterSpacing: -0.5,
//                 ),
//               ),
//               InkWell(
//                 onTap: controller.resetPrediction,
//                 borderRadius: BorderRadius.circular(20),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.refresh_rounded, color: primaryBlue),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         /// Pill-Shaped Tabs
//         Container(
//           height: 50,
//           margin: const EdgeInsets.symmetric(horizontal: 20),
//           decoration: BoxDecoration(
//             color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
//             borderRadius: BorderRadius.circular(25),
//             border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
//           ),
//           child: TabBar(
//             controller: _tabController,
//             indicatorSize: TabBarIndicatorSize.tab,
//             indicator: BoxDecoration(
//               color: primaryBlue,
//               borderRadius: BorderRadius.circular(25),
//               boxShadow: [
//                 BoxShadow(color: primaryBlue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2)),
//               ],
//             ),
//             labelColor: Colors.white,
//             unselectedLabelColor: isDark ? Colors.white54 : Colors.grey.shade600,
//             labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
//             dividerColor: Colors.transparent,
//             padding: const EdgeInsets.all(4),
//             tabs: const [
//               Tab(text: "Safe"),
//               Tab(text: "Moderate"),
//               Tab(text: "Ambitious"),
//               Tab(text: "Other"),
//             ],
//           ),
//         ),

//         const SizedBox(height: 20),

//         Expanded(
//           child: TabBarView(
//             controller: _tabController,
//             children: [
//               _buildCollegeList(controller.safe, successGreen, "Safe Bet", isDark),
//               _buildCollegeList(controller.moderate, accentBlue, "Possible", isDark),
//               _buildCollegeList(controller.ambitious, warningOrange, "Hard", isDark),
//               _buildCollegeList(controller.noCutoff, neutralGrey, "No Data", isDark),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCollegeList(
//       List<CollegeModel> colleges, Color badgeColor, String badgeText, bool isDark) {
//     if (colleges.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(Icons.analytics_outlined, size: 48, color: isDark ? Colors.white24 : Colors.grey.shade400),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               "No colleges found here",
//               style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade500, fontSize: 15),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       itemCount: colleges.length,
//       itemBuilder: (context, index) {
//         final college = colleges[index];
//         final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;

//         return Container(
//           margin: const EdgeInsets.only(bottom: 16),
//           decoration: BoxDecoration(
//             color: cardBg,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               if (!isDark)
//                 BoxShadow(
//                   color: const Color(0xFF94A3B8).withOpacity(0.1),
//                   blurRadius: 15,
//                   offset: const Offset(0, 5),
//                 ),
//             ],
//             border: Border.all(
//               color: isDark ? Colors.white10 : Colors.grey.shade100,
//             ),
//           ),
//           child: InkWell(
//             borderRadius: BorderRadius.circular(20),
//             onTap: () {},
//             child: Padding(
//               padding: const EdgeInsets.all(18),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: badgeColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: Icon(Icons.school, color: badgeColor, size: 22),
//                       ),
//                       const SizedBox(width: 14),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               college.collegeName,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 color: isDark ? Colors.white : const Color(0xFF1E293B),
//                                 height: 1.3,
//                               ),
//                             ),
//                             const SizedBox(height: 6),
//                             Row(
//                               children: [
//                                 Icon(Icons.location_on_rounded, size: 14, color: isDark ? Colors.white38 : Colors.grey.shade500),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   "${college.city}, ${college.state}",
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: isDark ? Colors.white54 : Colors.grey.shade600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Container(
//                     height: 1,
//                     color: isDark ? Colors.white10 : Colors.grey.shade100,
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Last Cutoff",
//                             style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey.shade500, fontWeight: FontWeight.w600),
//                           ),
//                           const SizedBox(height: 2),
//                           Text(
//                             "#${college.cutoffAirLast ?? 'N/A'}",
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1E293B)),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: badgeColor,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           badgeText,
//                           style: const TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // ==========================================================
//   // 🤖 AI OVERLAY
//   // ==========================================================
//   Widget _buildAiOverlay(bool isDark) {
//     return Positioned.fill(
//       child: Stack(
//         children: [
//           // Glass Morphism Blur
//           BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//             child: Container(
//               color: isDark ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.5),
//             ),
//           ),
//           Center(
//             child: Container(
//               width: 320,
//               padding: const EdgeInsets.all(30),
//               decoration: BoxDecoration(
//                 color: isDark ? const Color(0xFF1E293B) : Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: [
//                   BoxShadow(
//                     color: primaryBlue.withOpacity(0.2),
//                     blurRadius: 40,
//                     spreadRadius: 10,
//                   ),
//                 ],
//                 border: Border.all(color: Colors.white.withOpacity(isDark ? 0.1 : 0.8)),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Lottie.asset(
//                     "assets/lottie/predicationAI.json", // Ensure this path is correct
//                     height: 120,
//                     fit: BoxFit.contain,
//                   ),
//                   const SizedBox(height: 24),
//                   const Text(
//                     "Analyzing Your Rank...",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     "Our AI is scanning thousands of college records to find your perfect match.",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 13,
//                       height: 1.5,
//                       color: isDark ? Colors.white60 : Colors.grey.shade600,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: LinearProgressIndicator(
//                       minHeight: 6,
//                       backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
//                       valueColor: AlwaysStoppedAnimation(primaryBlue),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart'; // Optional: for better typography
import '../controller/prediction_controller.dart';

class PredictionView extends StatefulWidget {
  const PredictionView({super.key});

  @override
  State<PredictionView> createState() => _PredictionViewState();
}

class _PredictionViewState extends State<PredictionView> {
  final PredictionController controller = Get.put(PredictionController());

  // Modern Color Palette
  final Color primaryBrand = const Color(0xFF2563EB); // Royal Blue
  final Color darkSurface = const Color(0xFF1E293B); // Slate 800
  final Color lightSurface = const Color(0xFFFFFFFF);
  final Color inputFillLight = const Color(0xFFF8FAFC); // Slate 50
  final Color inputFillDark = const Color(0xFF0F172A); // Slate 900

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF020617) : const Color(0xFFF1F5F9);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "College Predictor",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600, 
            color: Colors.white,
            fontSize: 20
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF1E3A8A), const Color(0xFF0F172A)]
                      : [const Color(0xFF2563EB), const Color(0xFF1D4ED8)],
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Stack(
                children: [
                  // Decorative Circles
                  Positioned(
                    top: -50,
                    right: -50,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: -20,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Floating Rank Card
                  _buildRankCard(isDark),
                  
                  const SizedBox(height: 34),
                  
                  // Form Container
                  _buildFormContainer(isDark, textColor),
                  
                  const SizedBox(height: 100), // Space for bottom
                ],
              ),
            ),
          ),

          // Loading Overlay
          Obx(() {
            if (controller.isPredictionLoading.value) {
              return _buildAiOverlay(isDark);
            }
            return const SizedBox();
          }),
        ],
      ),
      
      // Floating Action Button styled as bottom bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? darkSurface : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ]
        ),
        child: SafeArea(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: controller.fetchPrediction,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBrand,
                elevation: 4,
                shadowColor: primaryBrand.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    "Predict My Colleges",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // RANK CARD (Floating Effect)
  // ==========================================================
  Widget _buildRankCard(bool isDark) {
    return Obx(() => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Your All India Rank (AIR)",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF9333EA)],
            ).createShader(bounds),
            child: Text(
              controller.userAir.value == 0
                  ? "Loading..."
                  : "#${controller.userAir.value}",
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Masked by shader
              ),
            ),
          ),
        ],
      ),
    ));
  }

  // ==========================================================
  // FORM CONTAINER
  // ==========================================================
  Widget _buildFormContainer(bool isDark, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 16),
          child: Text(
            "Prediction Details",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),

        _buildModernInput(
          label: "Home State",
          hint: "e.g. Maharashtra, Delhi",
          icon: Icons.map_outlined,
          isDark: isDark,
          onChanged: (v) => controller.selectedState.value = v,
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: _buildModernInput(
                label: "Category",
                hint: "Gen/OBC",
                icon: Icons.category_outlined,
                isDark: isDark,
                onChanged: (v) => controller.selectedCategory.value = v,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildModernInput(
                label: "Year",
                hint: "2024",
                icon: Icons.calendar_today_outlined,
                keyboard: TextInputType.number,
                isDark: isDark,
                onChanged: (v) => controller.selectedYear.value = int.tryParse(v),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        _buildModernInput(
          label: "Course Preference",
          hint: "MBBS,BDS",
          icon: Icons.school_outlined,
          isDark: isDark,
          onChanged: (v) => controller.selectedCourse.value = v,
        ),

        const SizedBox(height: 16),

        _buildModernInput(
          label: "Quota",
          hint: "All India / Home State",
          icon: Icons.verified_outlined,
          isDark: isDark,
          onChanged: (v) => controller.selectedQuota.value = v,
        ),

        const SizedBox(height: 16),

        _buildModernInput(
          label: "Counselling Round",
          hint: "Round 1, 2, or Mock",
          icon: Icons.layers_outlined,
          isDark: isDark,
          onChanged: (v) => controller.selectedRound.value = v,
        ),
      ],
    );
  }

  Widget _buildModernInput({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    required bool isDark,
    TextInputType keyboard = TextInputType.text,
  }) {
    final fillColor = isDark ? inputFillDark : inputFillLight;
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade200;
    final labelColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final textColor = isDark ? Colors.white : Colors.black87;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: TextField(
            style: GoogleFonts.poppins(color: textColor, fontWeight: FontWeight.w500),
            keyboardType: keyboard,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: Icon(icon, color: primaryBrand.withOpacity(0.8), size: 22),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // AI LOADING OVERLAY
  // ==========================================================
  Widget _buildAiOverlay(bool isDark) {
    return Positioned.fill(
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            color: (isDark ? Colors.black : Colors.white).withOpacity(0.6),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryBrand.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Lottie.asset(
                      "assets/lottie/predicationAI.json",
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Analyzing Your Rank...",
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Searching through college databases",
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600]),
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