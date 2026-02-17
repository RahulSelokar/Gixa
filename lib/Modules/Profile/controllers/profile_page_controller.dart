import 'package:get/get.dart';

class ProfileController extends GetxController {
  final name = "Kanhaiya".obs;
  final state = "Madhya Pradesh".obs;
  final air = "1250".obs;
  final score = "720".obs;

  // Basic Details
  final email = "kanhaiya@email.com".obs;
  final phone = "+91 9876543210".obs;

  // Education
  final course = "MBBS".obs;
  final year = "2024".obs;

  // Address
  final address = "Bhopal, MP".obs;

  // ✅ FIX: Documents must be RxList
  final RxList<String> documents = <String>[
    "10th Marksheet",
    "12th Marksheet",
    "NEET Score",
  ].obs;
}
