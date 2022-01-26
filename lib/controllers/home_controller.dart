import 'dart:async';

import 'package:deart/controllers/user_controller.dart';
import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/models/enums/sentry_mode_state.dart';
import 'package:deart/models/vehicle.dart';
import 'package:deart/utils/tesla_api.dart';
import 'package:deart/utils/unit_utils.dart';
import 'package:get/get.dart';
import 'package:quick_actions/quick_actions.dart';

class HomeController extends GetxController {
  TeslaAPI api = Get.find<TeslaAPI>();
  Rx<int?> vehicleId = Rx(null);
  RxString vehicleName = ''.obs;
  RxDouble batteryRange = 0.0.obs;
  RxInt batteryLevel = 0.obs;
  RxString sentryModeStateText = 'Unknown'.obs;
  Rx<List<Vehicle>?> vehicles = Rx(null);

  final List<StreamSubscription> subscriptions = [];

  @override
  void onInit() {
    Get.find<UserController>().vehicles.listenAndPump((data) {
      if (data != null) {
        vehicles.value = data;
      }
    });

    initQuickActions();

    subscribeToVehicle();
    super.onInit();
  }

  void initQuickActions() {
    const QuickActions quickActions = QuickActions();
    quickActions.initialize((shortcutType) {
      switch (shortcutType) {
        case 'sentry_on':
          turnOnSentry();
          break;
        case 'sentry_off':
          turnOffSentry();
          break;
        case 'horn':
          horn();
          break;
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'sentry_on',
        localizedTitle: 'Arm Sentry',
      ),
      const ShortcutItem(
        type: 'sentry_off',
        localizedTitle: 'Disarm Sentry',
      ),
      const ShortcutItem(
        type: 'horn',
        localizedTitle: 'Horn',
      )
    ]);
  }

  void subscribeToVehicle() {
    subscriptions.add(
      Get.find<UserController>().selectedVehicle.listenAndPump((data) {
        if (data != null) {
          vehicleId.value = data.id;
          vehicleName.value = data.displayName;
        }
      }),
    );

    subscriptions.add(
      Get.find<VehicleController>().vehicleData.listenAndPump((vehicleData) {
        if (vehicleData != null) {
          batteryLevel.value = vehicleData.chargeState.batteryLevel;
          batteryRange.value = mileToKM(vehicleData.chargeState.batteryRange);
        }
      }),
    );

    subscriptions.add(
      Get.find<VehicleController>()
          .sentryModeState
          .listenAndPump((sentryModeState) {
        sentryModeStateText.value = getSentryModeStateText(sentryModeState);
      }),
    );
  }

  void turnOnSentry() async {
    Get.snackbar(
      'Sentry Mode',
      'Activating...',
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );

    Get.find<VehicleController>().toggleSentry(true);

    Get.snackbar(
      'Sentry Mode',
      'Activated succesfully.',
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );
  }

  void turnOffSentry() async {
    Get.snackbar(
      'Sentry Mode',
      'Deactivating...',
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );

    Get.find<VehicleController>().toggleSentry(false);

    Get.snackbar(
      'Sentry Mode',
      'Deactivated succesfully.',
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );
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

  String getSentryModeStateText(SentryModeState sentryModeState) {
    switch (sentryModeState) {
      case SentryModeState.unknown:
        return "Unknown";
      case SentryModeState.off:
        return "Off";
      case SentryModeState.on:
        return "Engaged";
    }
  }

  @override
  void onClose() {
    // Close subscriptions.
    for (var element in subscriptions) {
      element.cancel();
    }

    super.onClose();
  }
}
