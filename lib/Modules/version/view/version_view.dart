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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('update_available'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${'new_version'.tr}: ${versionModel.latestVersion}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(versionModel.releaseNotes),
          ],
        ),
        actions: [
          if (versionModel.updateType != "force")
            TextButton(onPressed: () => Get.back(), child: Text('later'.tr)),
          ElevatedButton(onPressed: _launchStore, child: Text('update_now'.tr)),
        ],
      ),
    );
  }
}
