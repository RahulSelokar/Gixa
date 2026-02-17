// import 'package:Gixa/Modules/recomandation/model/college_model.dart';
// import 'package:flutter/material.dart';

// class CollegeCard extends StatelessWidget {
//   final CollegeModel college;

//   const CollegeCard({super.key, required this.college});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 230,
//       height: 100,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//             child: Image.network(
//               college.image,
//               height: 80,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       "${college.rating} ★",
//                       style: const TextStyle(
//                         color: Colors.blue,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const Spacer(),
//                     const Icon(Icons.bookmark_border, size: 20),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   college.rankText,
//                   style:
//                       const TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   college.name,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   "${college.city}, ${college.state}",
//                   style:
//                       const TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
