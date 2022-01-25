import 'package:deart/controllers/car_controller.dart';
import 'package:deart/globals.dart';
import 'package:deart/models/charge_state.dart';
import 'package:deart/models/enums/sentry_mode_state.dart';
import 'package:deart/models/vehicle.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:deart/utils/tesla_api.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';

class HomeController extends GetxController {
  Rx<ChargeState?> chargeState = Rx<ChargeState?>(null);
  TeslaAPI api = Get.find<TeslaAPI>();
  Rx<SentryModeState> sentryModeState = Rx(SentryModeState.unknown);

  HomeController() {
    Get.put(CarController());
  }

  @override
  void onInit() async {
    // Load Vehicle Settings.
    loadVehicle().then((value) async {
      await loadChargeState();
      await api.wakeUp();
    });

    // Init
    sentryModeState.value = Get.find<CarController>().sentryModeState.value;

    // And listen for changes.
    Get.find<CarController>().sentryModeState.listen((state) {
      sentryModeState.value = state;
    });

    super.onInit();
  }

  Future loadVehicle() async {
    Vehicle? vehicle = await api.getVehicle();
    if (vehicle != null) {
      Globals.vehicleId = vehicle.id;
      await writeStorageKey('vehicleId', vehicle.id.toString());

      CarController carContorller = Get.find<CarController>();
      carContorller.vehicleId.value = vehicle.id;
      carContorller.vehicleName.value =
          HtmlUnescape().convert(vehicle.displayName);
    }
  }

  Future loadChargeState() async {
    ChargeState? result = await api.chargeState();
    chargeState.value = result;

    update();
  }

  void turnOnSentry() async {
    Get.snackbar(
      'Sentry Mode',
      'Activating...',
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );

    bool success = await api.toggleSentry(true);

    Get.snackbar(
      'Sentry Mode',
      'Activated succesfully.',
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );

    if (success) {
      Get.find<CarController>().setSentryState(SentryModeState.on);
    } else {
      Get.find<CarController>().setSentryState(SentryModeState.unknown);
    }
  }

  void turnOffSentry() async {
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
      Get.find<CarController>().setSentryState(SentryModeState.off);
    } else {
      Get.find<CarController>().setSentryState(SentryModeState.unknown);
    }
  }

  void horn() async {
    await api.horn();

    Get.snackbar(
      'Beep beep',
      'Don\'t disturb your neighbors!',
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );
  }

  void flashLights() async {
    await api.flashLights();

    Get.snackbar(
      'Blink Blink',
      'It\'s too shiny!',
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );
  }

  void goToSettings() {
    Get.toNamed('/settings');
  }

  Future refreshState() async {
    return loadVehicle().then((value) async {
      await loadChargeState();

      // Wake up the car
      await api.wakeUp();
    });
  }

  String sentryModeStateText(SentryModeState sentryModeState) {
    switch (sentryModeState) {
      case SentryModeState.unknown:
        return "Unknown";
      case SentryModeState.off:
        return "Off";
      case SentryModeState.on:
        return "Engaged";
    }
  }
}
