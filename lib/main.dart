import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  await GetStorage.init();

  await NotificationService.init();

  /// Controllers
  Get.put(ProfileController(), permanent: true);

  runApp(const Gixa());
}
