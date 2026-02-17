import 'package:Gixa/utils/themes/widgets_themes/app_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/complete_profile_controller.dart';

class CompleteProfilePage extends StatelessWidget {
  CompleteProfilePage({super.key});

  final controller = Get.put(CompleteProfileController());

  @override
  Widget build(BuildContext context) {
    /// receive phone from OTP flow
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['phone'] != null) {
      controller.setPhone(args['phone']);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Let's get you started")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 📱 VERIFIED PHONE
            AppInput(
              label: 'Mobile Number',
              controller: controller.phoneController,
              readOnly: true,
              suffixIcon: const Icon(Icons.check_circle, color: Colors.green),
            ),

            const SizedBox(height: 20),

            /// 👤 ROLE
            DropdownButtonFormField<String>(
              initialValue: controller.role.value,
              decoration: const InputDecoration(labelText: 'I am a'),
              items: const [
                'Student',
                'Parent',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => controller.role.value = v!,
            ),

            const SizedBox(height: 20),

            /// 📝 NAME
            AppInput(
              label: 'Name',
              onChanged: (v) => controller.name.value = v,
            ),

            const SizedBox(height: 20),

            /// ✉️ EMAIL
            AppInput(
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              onChanged: (v) => controller.email.value = v,
            ),

            const SizedBox(height: 20),

            /// 🎓 COURSE
            DropdownButtonFormField<String>(
              initialValue: controller.course.value,
              decoration: const InputDecoration(labelText: 'Select Course'),
              items: const [
                'UG',
                'PG',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => controller.course.value = v!,
            ),

            const SizedBox(height: 20),

            /// 📘 EXAM (LOCKED)
            DropdownButtonFormField<String>(
              initialValue: controller.exam.value,
              decoration: const InputDecoration(labelText: 'Select Exam'),
              items: const [
                'NEET',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: null,
            ),

            const SizedBox(height: 32),

            /// 🧪 NEET DETAILS
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'NEET Details (cannot be edited later)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            const SizedBox(height: 16),

            AppInput(
              label: 'NEET Score',
              keyboardType: TextInputType.number,
              onChanged: (v) => controller.neetScore.value = v,
            ),

            const SizedBox(height: 16),

            AppInput(
              label: 'AIR Rank',
              keyboardType: TextInputType.number,
              onChanged: (v) => controller.airRank.value = v,
            ),

            const SizedBox(height: 40),

            /// ✅ SUBMIT
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.validateNeetDetails()) {
                    // call create profile API
                  }
                },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
