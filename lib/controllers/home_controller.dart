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
  Rx<List<Vehicle>?> vehicles = Rx(null);

  HomeController() {
    Get.put(CarController());
  }

  @override
  void onInit() async {
    // Load Vehicle Settings.
    loadVehicles().then((value) async {
      await loadChargeState();
    });

    // Init
    sentryModeState.value = Get.find<CarController>().sentryModeState.value;

    // And listen for changes.
    Get.find<CarController>().sentryModeState.listen((state) {
      sentryModeState.value = state;
    });

    super.onInit();
  }

  Future loadVehicles() async {
    // Load Vehicles from API
    vehicles.value = await api.getVehicles();
    if (vehicles.value != null && vehicles.value!.isNotEmpty) {
      // Auto select first vehicle
      Vehicle vehicle;
      if (vehicles.value!.length == 1) {
        vehicle = vehicles.value!.first;
      } else {
        if (Globals.vehicleId == null) {
          vehicle = vehicles.value!.first;
        } else {
          vehicle = vehicles.value!
              .firstWhere((element) => (element.id == Globals.vehicleId));
        }
      }
      carChanged(vehicle.id);
      CarController carContorller = Get.find<CarController>();
      carContorller.vehicleId.value = vehicle.id;
      carContorller.vehicleName.value = HtmlUnescape().convert(
        vehicle.displayName,
      );
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
    return loadVehicles().then((value) async {
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

  carChanged(
    int? vehicleId, {
    bool reloadData = false,
  }) async {
    // Set selected vehicle id
    Globals.vehicleId = vehicleId;
    await writeStorageKey('vehicleId', vehicleId.toString());

    // Set selected Vehicle name
    String vehicleName =
        vehicles.value!.firstWhere((x) => x.id == vehicleId).displayName;
    await writeStorageKey('vehicleName', vehicleName.toString());

    if (reloadData) {
      // Reload data if car changed
      await loadChargeState();
      await api.wakeUp();
    }
  }
}
