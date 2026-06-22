import 'package:Gixa/Modules/Chatbot/controller/chatbot_controller.dart';
import 'package:get/get.dart';

class AdmissionChatBinding extends Bindings {
  static const String controllerTag = 'admission-chat';

  @override
  void dependencies() {
    if (!Get.isRegistered<ChatController>(tag: controllerTag)) {
      Get.put(
        ChatController(autoStart: false, storagePrefix: controllerTag),
        tag: controllerTag,
        permanent: true,
      );
    }
  }
}
