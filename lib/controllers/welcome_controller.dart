import 'package:deart/controllers/home_controller.dart';
import 'package:deart/services/auth_service.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:get/get.dart';

import '../globals.dart';

class WelcomeController extends GetxController {
  RxBool isLoggedIn = RxBool(false);
  RxString appName = RxString('DearT');

  @override
  void onInit() {
    initServices();

    super.onInit();
  }

  @override
  void onReady() async {
    await initSettings();
    if (isLoggedIn.value) {
      Get.put(HomeController());
      Get.offAndToNamed('/home');
    } else {
      Get.offAndToNamed('/login');
    }
    super.onReady();
  }

  void initServices() {
    Get.put(AuthService());
  }

  Future initSettings() async {
    Globals.apiAccessToken = await readStorageKey('accessToken');
    if (Globals.apiAccessToken != null) {
      isLoggedIn.value = true;

      Globals.apiRefreshToken = await readStorageKey('refreshToken');
      Globals.apiAccessTokenExpiryTime =
          DateTime?.parse((await readStorageKey('accessTokenExpiryTime'))!);

      String? vehicleIdText = await readStorageKey('vehicleId');
      if (vehicleIdText != null) {
        Globals.vehicleId = int.tryParse(vehicleIdText);
      }

      if (Globals.apiAccessTokenExpiryTime != null) {
        if (DateTime.now()
            .add(
              const Duration(
                minutes: 30,
              ),
            )
            .isAfter(
              Globals.apiAccessTokenExpiryTime!,
            )) {
          await Get.find<AuthService>().refreshToken();
        }
      }
    } else {
      isLoggedIn.value = false;
      Get.find<AuthService>().changeToken();
    }
  }
}
