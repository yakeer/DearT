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

    super.onInit();
  }

  @override
  void onReady() async {
    // Listen to LoggedIn Stream to navigate to login page.
    Get.find<AppController>().isLoggedIn.listen((loggedIn) {
      if (!loggedIn) {
        Get.offAllNamed(
          '/login',
        );
      } else {
        Get.offAllNamed('/home');
      }
    });

    super.onReady();
  }

  void initServices() {
    Get.put(TeslaAPI(), permanent: true);
    Get.put(AuthService(), permanent: true);
  }
}
