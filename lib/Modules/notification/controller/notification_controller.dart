import 'package:get/get.dart';

class NotificationController extends GetxController {
  final notifications = <String>[
    'Profile updated',
    'New course added',
    'NEET counseling update',
  ].obs;
}
