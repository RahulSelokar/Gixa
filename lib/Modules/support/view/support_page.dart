import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/support_controller.dart';

class SupportPage extends StatelessWidget {
  SupportPage({super.key});

  final SupportController controller =
      Get.put(SupportController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Support"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final contact = controller.contact.value;

        if (contact == null) {
          return const Center(
            child: Text("No Support Information Available"),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.support_agent,
                    size: 60,
                  ),
                  const SizedBox(height: 20),

                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text("Phone Number"),
                    subtitle: Text(contact.phoneNumber),
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text("Email"),
                    subtitle: Text(contact.email),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
