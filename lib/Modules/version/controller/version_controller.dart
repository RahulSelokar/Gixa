import 'package:Gixa/Modules/version/model/version_model.dart';
import 'package:Gixa/Modules/version/view/version_view.dart';
import 'package:Gixa/services/version_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionController extends GetxController {
  final isChecking = false.obs;
  VersionModel? versionData;

  /// 🔹 Check App Version
  Future<void> checkAppVersion() async {
    try {
      isChecking.value = true;

      // Get installed app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      // Call API
      final response = await VersionService.checkVersion(
        platform: "android",
        currentVersion: currentVersion,
      );

      versionData = response;

      // If update required → show dialog
      if (response.updateRequired) {
        Get.dialog(
          UpdateDialog(versionModel: response),
          barrierDismissible: response.updateType != "force",
        );
      }
    } catch (e) {
      debugPrint("❌ Version Check Error: $e");
    } finally {
      isChecking.value = false;
    }
  }
}
