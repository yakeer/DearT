import 'package:deart/controllers/car_controller.dart';
import 'package:deart/controllers/home_controller.dart';
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

    Get.delete<HomeController>();

    Get.offAllNamed('/');
  }
}
