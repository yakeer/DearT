import 'package:deart/services/auth_service.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  RxBool wakeUp = RxBool(true);

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  void logout() async {
    await Get.find<AuthService>().logout();

    Get.offAllNamed('/');
  }
}
