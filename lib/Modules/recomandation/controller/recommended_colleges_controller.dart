// import 'package:Gixa/Modules/recomandation/model/college_model.dart';
// import 'package:Gixa/Modules/recomandation/model/static_colleges.dart';
// import 'package:get/get.dart';

// class RecommendedCollegesController extends GetxController {
//   final isGovt = true.obs;
//   final isPopular = true.obs;

//   final colleges = <CollegeModel>[].obs;

//   @override
//   void onInit() {
//     filterColleges();
//     super.onInit();
//   }

//   void filterColleges() {
//     colleges.value =
//         staticColleges.where((c) => c.isGovt == isGovt.value).toList();
//   }

//   void toggleGovt(bool value) {
//     isGovt.value = value;
//     filterColleges();
//   }

//   void togglePopularity(bool popular) {
//     isPopular.value = popular;
//   }
// }
