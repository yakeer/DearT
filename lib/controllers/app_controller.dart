import 'package:deart/controllers/user_controller.dart';
import 'package:deart/controllers/work_flow_controller.dart';
import 'package:deart/globals.dart';
import 'package:deart/services/auth_service.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  RxBool isLoggedIn = RxBool(false);
  RxBool isDataLoaded = RxBool(false);
  Rx<int?> selectedVehicleId = Rx(null);
  Rx<String?> selectedVehicleName = Rx(null);

  @override
  void onReady() async {
    await initSettings();
    super.onReady();
  }

  Future initSettings() async {
    isLoggedIn.value = await initDataFromStorage();
  }

  Future<bool> initDataFromStorage() async {
    // Load Auth Data
    bool isLoggedIn = await initAuthDataFromStorage();
    if (isLoggedIn) {
      int? vehicleId = await loadVehicleIdFromStorage();

      UserController userController = Get.put(
        UserController(vehicleId),
        permanent: true,
      );

      Get.put(
        WorkFlowController(),
        permanent: true,
      );

      await userController.initVehicles();
    }
    return isLoggedIn;
  }

  Future<bool> initAuthDataFromStorage() async {
    Globals.apiAccessToken = await readStorageKey('accessToken');
    if (Globals.apiAccessToken != null) {
      Globals.apiRefreshToken = await readStorageKey('refreshToken');

      if (await containsStorageKey('accessTokenExpiryTime')) {
        String? expiryTimeText = await readStorageKey('accessTokenExpiryTime');
        if (expiryTimeText != null) {
          Globals.apiAccessTokenExpiryTime = DateTime?.tryParse(expiryTimeText);
        }
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

      return true;
    } else {
      return false;
    }
  }

  Future<int?> loadVehicleIdFromStorage() async {
    int? vehicleId;

    String? vehicleIdText = await readStorageKey('vehicleId');
    if (vehicleIdText != null) {
      vehicleId = int.tryParse(vehicleIdText);

      Globals.vehicleId = vehicleId;

      selectedVehicleId.value = vehicleId;
    }

    String? vehicleName = await readStorageKey('vehicleName');
    if (vehicleName != null) {
      selectedVehicleName.value = vehicleName;
    }

    return vehicleId;
  }
}
