import 'package:deart/controllers/app_controller.dart';
import 'package:deart/services/auth_service.dart';
import 'package:deart/utils/tesla_api.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  RxString appName = RxString('DearT');

  @override
  void onInit() {
    initServices();
    // Init App Controller
    Get.create<AppController>(
      () => AppController(),
      permanent: true,
    );

    Get.find<AppController>().isLoggedIn.listen((loggedIn) {
      if (loggedIn) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed(
          '/login',
        );
      }
    });

    super.onInit();
  }

  // @override
  // void onReady() async {
  //   super.onReady();
  // }

  void initServices() {
    Get.create(() => TeslaAPI(), permanent: true);
    Get.create(() => AuthService(), permanent: true);
  }
}
