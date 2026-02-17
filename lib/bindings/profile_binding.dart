import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

class ProfileBinding extends Bindings{
  @override
  // TODO: implement runtimeType
void dependencies(){
  Get.lazyPut<ProfileController>(() => ProfileController());
}
}