import 'package:Gixa/Modules/notification/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  final controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const Center(child: Text('No notifications'));
        }

        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (_, i) => ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(controller.notifications[i]),
          ),
        );
      }),
    );
  }
}
