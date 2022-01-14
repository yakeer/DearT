import 'package:deart/globals.dart';
import 'package:deart/models/charge_state.dart';
import 'package:deart/models/vehicle.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:deart/utils/tesla_api.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxString vehicleName = RxString('N/A');
  Rx<ChargeState?> chargeState = Rx<ChargeState?>(null);
  Rx<String> commandStatus = RxString('Ready.');
  TeslaAPI api = TeslaAPI();

  @override
  void onInit() async {
    await loadVehicle();

    // Load Vehicle Settings.

    await loadChargeState();

    // Wake up the car
    await api.wakeUp();

    super.onInit();
  }

  Future loadVehicle() async {
    Vehicle? vehicle = await api.getVehicle();
    if (vehicle != null) {
      Globals.vehicleId = vehicle.id;
      await writeStorageKey('vehicleId', vehicle.id.toString());

      vehicleName.value = vehicle.displayName;
    }
  }

  Future loadChargeState() async {
    ChargeState? result = await api.chargeState();
    chargeState.value = result;
  }

  void turnOnSentry() async {
    Get.snackbar(
      'Sentry Mode',
      'Activating...',
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );

    commandStatus.value = 'Activating...';
    bool success = await api.toggleSentry(true);

    Get.snackbar(
      'Sentry Mode',
      'Activated succesfully.',
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );

    if (success) {
      commandStatus.value = 'Activated.';
    } else {
      commandStatus.value = 'Error Activating!';
    }
  }

  void turnOffSentry() async {
    commandStatus.value = 'Deactivating...';

    Get.snackbar(
      'Sentry Mode',
      'Deactivating...',
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );

    bool success = await api.toggleSentry(false);

    Get.snackbar(
      'Sentry Mode',
      'Deactivated succesfully.',
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );

    if (success) {
      commandStatus.value = 'Deactivated.';
    } else {
      commandStatus.value = 'Error Deactivating!';
    }
  }

  void horn() async {
    await api.horn();
  }

  void flashLights() async {
    await api.flashLights();
  }
}
