// import 'package:Gixa/Modules/recomandation/controller/recommended_colleges_controller.dart';
// import 'package:Gixa/Modules/recomandation/view/collage_card.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class RecommendedCollegesSlider extends StatelessWidget {
//   const RecommendedCollegesSlider({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(RecommendedCollegesController());

//     return Obx(() {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _header(controller),
//           const SizedBox(height: 14),
//           SizedBox(
//             height: 240,
//             child: ListView.separated(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               scrollDirection: Axis.horizontal,
//               itemCount: controller.colleges.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 14),
//               itemBuilder: (_, index) =>
//                   CollegeCard(college: controller.colleges[index]),
//             ),
//           ),
//         ],
//       );
//     });
//   }

//   Widget _header(RecommendedCollegesController controller) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Expanded(
//                 child: Text(
//                   "Recommended Indian colleges",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               DropdownButton<bool>(
//                 value: controller.isGovt.value,
//                 underline: const SizedBox(),
//                 items: const [
//                   DropdownMenuItem(value: true, child: Text("Govt.")),
//                   DropdownMenuItem(value: false, child: Text("Pvt.")),
//                 ],
//                 onChanged: (v) => controller.toggleGovt(v!),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               _tab(
//                 text: "Most Popular",
//                 active: controller.isPopular.value,
//                 onTap: () => controller.togglePopularity(true),
//               ),
//               const SizedBox(width: 8),
//               _tab(
//                 text: "Top Ranked",
//                 active: !controller.isPopular.value,
//                 onTap: () => controller.togglePopularity(false),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _tab({
//     required String text,
//     required bool active,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: active ? Colors.orange.shade50 : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: active ? Colors.orange : Colors.grey.shade300,
//           ),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             color: active ? Colors.orange : Colors.grey.shade700,
//           ),
//         ),
//       ),
//     );
//   }
// }
