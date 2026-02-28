import 'package:Gixa/Modules/version/model/version_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatelessWidget {
  final VersionModel versionModel;

  const UpdateDialog({super.key, required this.versionModel});

  Future<void> _launchStore() async {
    final Uri url = Uri.parse(versionModel.storeUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => versionModel.updateType != "force",
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Update Available"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Version: ${versionModel.latestVersion}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(versionModel.releaseNotes),
          ],
        ),
        actions: [
          if (versionModel.updateType != "force")
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Later"),
            ),
          ElevatedButton(
            onPressed: _launchStore,
            child: const Text("Update Now"),
          ),
        ],
      ),
    );
  }
}