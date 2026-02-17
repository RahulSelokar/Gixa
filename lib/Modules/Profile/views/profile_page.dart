// import 'package:Gixa/Modules/Profile/controllers/profile_page_controller.dart';
// import 'package:Gixa/Modules/Profile/views/edit_profile.dart';
// import 'package:Gixa/Modules/Profile/views/profile_edit_section.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter/services.dart';

// class ProfileView extends StatelessWidget {
//   ProfileView({super.key});

//   final controller = Get.put(ProfileController());

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     // Using the Red accent color from the screenshot
//     final accentColor = const Color(0xFFE53935);

//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
//           onPressed: () => Get.back(),
//         ),
//         // title: Text(
//         //   "My Profile",
//         //   style: theme.textTheme.titleLarge?.copyWith(
//         //     fontWeight: FontWeight.bold,
//         //     fontSize: 20,
//         //     color: theme.colorScheme.onSurface,
//         //   ),
//         // ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.settings_outlined,
//               color: theme.colorScheme.onSurface,
//             ),
//             onPressed: () {},
//           ),
//           const SizedBox(width: 8),
//           IconButton(
//             icon: Icon(Icons.edit, color: theme.colorScheme.onSurface),
//             onPressed: () => _openEdit(ProfileEditSection.basic),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),

//             // 1. HEADER (Avatar + Name + Edit Button)
//             _buildHeader(theme, accentColor),

//             const SizedBox(height: 30),

//             // 2. STATS (Kept this as it's important data, but styled minimally)
//             _buildStatsRow(theme),

//             const SizedBox(height: 20),
//             const Divider(thickness: 1, height: 1),

//             // 3. MENU LIST (Data fields styled like the menu items in the image)

//             // --- Contact Info ---
//             _buildSectionHeader(theme, "Contact Information"),
//             _buildMenuTile(
//               theme,
//               icon: Icons.email_outlined,
//               label: "Email Address",
//               rxValue: controller.email,
//               onTap: () => _openEdit(ProfileEditSection.basic),
//             ),
//             _buildMenuTile(
//               theme,
//               icon: Icons.phone_outlined,
//               label: "Phone Number",
//               rxValue: controller.phone,
//               onTap: () => _openEdit(ProfileEditSection.basic),
//             ),

//             // --- Education & Location ---
//             _buildSectionHeader(theme, "Academic & Location"),
//             _buildMenuTile(
//               theme,
//               icon: Icons.school_outlined,
//               label: "Course / Standard",
//               rxValue: controller.course,
//               onTap: () => _openEdit(ProfileEditSection.education),
//             ),
//             _buildMenuTile(
//               theme,
//               icon: Icons.location_on_outlined,
//               label: "Location",
//               rxValue: controller.address,
//               onTap: () => _openEdit(ProfileEditSection.address),
//             ),

//             // --- Documents (Dynamic List) ---
//             _buildSectionHeader(theme, "Documents"),
//             Obx(() {
//               if (controller.documents.isEmpty) {
//                 return _buildMenuTileStatic(
//                   theme,
//                   Icons.folder_off_outlined,
//                   "No documents",
//                   "Tap to upload",
//                   () => _openEdit(ProfileEditSection.documents),
//                 );
//               }
//               return Column(
//                 children: controller.documents.map((doc) {
//                   return _buildMenuTileStatic(
//                     theme,
//                     Icons.description_outlined,
//                     "Document",
//                     doc,
//                     () => _openEdit(ProfileEditSection.documents),
//                   );
//                 }).toList(),
//               );
//             }),

//             const SizedBox(height: 10),

//             // --- Logout ---
//             ListTile(
//               onTap: () {},
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 24,
//                 vertical: 8,
//               ),
//               leading: Icon(Icons.logout_rounded, color: accentColor, size: 24),
//               title: Text(
//                 "Log out",
//                 style: theme.textTheme.bodyLarge?.copyWith(
//                   color: accentColor,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               trailing: Icon(
//                 Icons.arrow_forward_ios_rounded,
//                 size: 16,
//                 color: accentColor.withOpacity(0.5),
//               ),
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }

//   void _openEdit(ProfileEditSection section) {
//     HapticFeedback.lightImpact();
//     Get.to(() => EditProfile(section: section));
//   }

//   // ==================== WIDGETS ====================

//   Widget _buildHeader(ThemeData theme, Color accentColor) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Avatar
//           Stack(
//             alignment: Alignment.bottomRight,
//             children: [
//               Container(
//                 width: 85,
//                 height: 85,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.grey.shade200,
//                   image: const DecorationImage(
//                     // Placeholder image or use controller.imageUrl
//                     image: NetworkImage("https://i.pravatar.cc/300"),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: theme.scaffoldBackgroundColor,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.camera_alt,
//                   size: 16,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(width: 20),

//           // Name and Button
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Obx(
//                   () => Text(
//                     controller.name.value,
//                     style: theme.textTheme.headlineSmall?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 22,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Obx(
//                   () => Text(
//                     "@${controller.name.value.replaceAll(' ', '').toLowerCase()}", // Generating a fake handle like image
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // Red Edit Button
//                 // SizedBox(
//                 //   height: 36,
//                 //   child: ElevatedButton(
//                 //     onPressed: () => _openEdit(ProfileEditSection.basic),
//                 //     style: ElevatedButton.styleFrom(
//                 //       backgroundColor: accentColor,
//                 //       foregroundColor: Colors.white,
//                 //       elevation: 0,
//                 //       padding: const EdgeInsets.symmetric(horizontal: 24),
//                 //       shape: RoundedRectangleBorder(
//                 //         borderRadius: BorderRadius.circular(8),
//                 //       ),
//                 //     ),
//                 //     child: const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.w600)),
//                 //   ),
//                 // )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Minimal Stats Row
//   Widget _buildStatsRow(ThemeData theme) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: Row(
//         children: [
//           Expanded(child: _buildSingleStat(theme, "AIR Rank", controller.air)),
//           const SizedBox(width: 15),
//           Expanded(child: _buildSingleStat(theme, "Score", controller.score)),
//         ],
//       ),
//     );
//   }

//   Widget _buildSingleStat(ThemeData theme, String label, RxString value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.withOpacity(0.1)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Obx(
//         () => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
//             const SizedBox(height: 4),
//             Text(
//               value.value,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(ThemeData theme, String title) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Text(
//           title.toUpperCase(),
//           style: TextStyle(
//             color: Colors.grey.shade500,
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 1.0,
//           ),
//         ),
//       ),
//     );
//   }

//   // Dynamic Tile (Observes RxString)
//   Widget _buildMenuTile(
//     ThemeData theme, {
//     required IconData icon,
//     required String label,
//     required RxString rxValue,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       onTap: onTap,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
//       leading: Icon(
//         icon,
//         color: theme.colorScheme.onSurface.withOpacity(0.7),
//         size: 22,
//       ),
//       title: Text(
//         label,
//         style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
//       ),
//       // We put the dynamic value in the trailing or subtitle.
//       // To match the image's clean look, we can put it as subtitle or trailing text.
//       subtitle: Obx(
//         () => Text(
//           rxValue.value.isEmpty ? "Not set" : rxValue.value,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
//         ),
//       ),
//       trailing: const Icon(
//         Icons.arrow_forward_ios_rounded,
//         size: 14,
//         color: Colors.grey,
//       ),
//     );
//   }

//   // Static Tile (For strings/docs)
//   Widget _buildMenuTileStatic(
//     ThemeData theme,
//     IconData icon,
//     String label,
//     String value,
//     VoidCallback onTap,
//   ) {
//     return ListTile(
//       onTap: onTap,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
//       leading: Icon(
//         icon,
//         color: theme.colorScheme.onSurface.withOpacity(0.7),
//         size: 22,
//       ),
//       title: Text(
//         label,
//         style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
//       ),
//       subtitle: Text(
//         value,
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//         style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
//       ),
//       trailing: const Icon(
//         Icons.arrow_forward_ios_rounded,
//         size: 14,
//         color: Colors.grey,
//       ),
//     );
//   }
// }
