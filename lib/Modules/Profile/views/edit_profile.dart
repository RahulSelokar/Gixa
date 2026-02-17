import 'package:Gixa/Modules/Profile/controllers/profile_page_controller.dart';
import 'package:Gixa/Modules/Profile/views/profile_edit_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatelessWidget {
  final ProfileEditSection section;

  EditProfile({super.key, required this.section});

  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildSection(),
      ),
    );
  }

  String _title() {
    switch (section) {
      case ProfileEditSection.basic:
        return "Edit Basic Details";
      case ProfileEditSection.education:
        return "Edit Education";
      case ProfileEditSection.address:
        return "Edit Address";
      case ProfileEditSection.documents:
        return "Edit Documents";
    }
  }

  Widget _buildSection() {
    switch (section) {
      case ProfileEditSection.basic:
        return _basicForm();
      case ProfileEditSection.education:
        return _educationForm();
      case ProfileEditSection.address:
        return _addressForm();
      case ProfileEditSection.documents:
        return _documentsForm();
    }
  }

  // ---------------- FORMS ----------------

  Widget _basicForm() {
    return _form([
      _field("Name", controller.name),
      _field("Email", controller.email),
      _field("Phone", controller.phone),
    ]);
  }

  Widget _educationForm() {
    return _form([
      _field("Course", controller.course),
      _field("Year", controller.year),
    ]);
  }

  Widget _addressForm() {
    return _form([
      _field("Address", controller.address),
    ]);
  }

  Widget _documentsForm() {
    return Column(
      children: controller.documents
          .map((e) => ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(e),
              ))
          .toList(),
    );
  }

  Widget _form(List<Widget> fields) {
    return Column(
      children: [
        ...fields,
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Get.back(),
            child: const Text("Save Changes"),
          ),
        ),
      ],
    );
  }

  Widget _field(String label, RxString value) {
    final controllerText = TextEditingController(text: value.value);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controllerText,
        onChanged: (v) => value.value = v,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
