import 'dart:io';
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/ticket/model/ticket_model.dart';
import 'package:Gixa/services/ticket_services.dart';
import 'package:get/get.dart';

class TicketController extends GetxController {
  /// ============================
  /// 🔄 Loading States
  /// ============================
  var isLoading = false.obs;
  var isListLoading = false.obs;
  var isDetailsLoading = false.obs;

  /// ============================
  /// 📝 Form Fields
  /// ============================
  var subject = "".obs;
  var description = "".obs;
  var errorMessage = "".obs;

  /// 🖼 Selected Media
  var selectedFile = Rxn<File>();

  /// ============================
  /// 📋 Tickets List
  /// ============================
  var tickets = <TicketModel>[].obs;

  /// ============================
  /// 📄 Selected Ticket Details
  /// ============================
  var selectedTicket = Rxn<TicketDetailsModel>();

  /// ============================
  /// 🔄 INIT
  /// ============================
  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }

  int? get _studentId => Get.find<ProfileController>().profile.value?.id;
  String get _studentEmail => Get.find<ProfileController>().email;

  /// ============================
  /// 📥 FETCH USER'S TICKETS
  /// ============================
  Future<void> fetchTickets() async {
    final id = _studentId;
    if (id == null) return;

    try {
      isListLoading.value = true;

      final data = await TicketService.getTickets(studentId: id);
      tickets.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Failed to load tickets");
    } finally {
      isListLoading.value = false;
    }
  }

  /// ============================
  /// 🎫 CREATE TICKET
  /// ============================
  Future<void> createTicket() async {
    if (subject.value.trim().isEmpty || description.value.trim().isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    final id = _studentId;
    final email = _studentEmail;
    if (id == null || email.isEmpty) {
      Get.snackbar("Error", "Profile not loaded");
      return;
    }

    try {
      isLoading.value = true;

      await TicketService.createTicket(
        studentId: id,
        studentEmail: email,
        subject: subject.value.trim(),
        description: description.value.trim(),
        mediaFile: selectedFile.value,
      );

      Get.snackbar("Success", "Ticket created successfully");

      /// Clear form
      subject.value = "";
      description.value = "";
      selectedFile.value = null;

      /// 🔄 Refresh Ticket List
      await fetchTickets();
    } catch (e) {
      Get.snackbar("Error", "Failed to create ticket");
    } finally {
      isLoading.value = false;
    }
  }

  /// ============================
  /// 📄 FETCH TICKET DETAILS
  /// ============================
  Future<bool> fetchTicketDetails(int ticketId) async {
    try {
      isDetailsLoading.value = true;

      final data = await TicketService.getTicketDetails(ticketId);

      selectedTicket.value = data;

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isDetailsLoading.value = false;
    }
  }

  void setMedia(File file) {
    selectedFile.value = file;
  }

  void clearForm() {
    subject.value = "";
    description.value = "";
    selectedFile.value = null;
  }
}
