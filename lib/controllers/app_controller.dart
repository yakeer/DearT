import 'package:deart/globals.dart';
import 'package:deart/services/auth_service.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  RxBool isLoggedIn = RxBool(false);
  Rx<int?> selectedVehicleId = Rx(null);
  Rx<String?> selectedVehicleName = Rx(null);

  @override
  void onReady() async {
    await initSettings();
    super.onReady();
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
        selectedVehicleId.value = Globals.vehicleId;
      }

      String? vehicleName = await readStorageKey('vehicleName');
      if (vehicleName != null) {
        selectedVehicleName.value = vehicleName;
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
    }
  }
}
