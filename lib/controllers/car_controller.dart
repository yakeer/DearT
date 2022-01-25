import 'dart:async';

import 'package:deart/controllers/app_controller.dart';
import 'package:deart/globals.dart';
import 'package:deart/models/enums/sentry_mode_state.dart';
import 'package:deart/models/vehicle_data.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:deart/utils/tesla_api.dart';
import 'package:get/get.dart';

class CarController extends GetxController {
  Rx<int?> vehicleId = Rx(null);
  RxString vehicleName = RxString('N/A');
  Rx<SentryModeState> sentryModeState = Rx(SentryModeState.unknown);
  Rx<VehicleData?> vehicleData = Rx(null);
  Rx<bool?> isOnline = Rx(null);

  TeslaAPI api = Get.find<TeslaAPI>();

  final List<StreamSubscription> subscriptions = [];

  @override
  void onInit() {
    _loadVehicleData();
    _loadSentryState();
    super.onInit();
  }

  void _loadVehicleData() async {
    if (Globals.vehicleId == null) {
      await Get.find<AppController>().loadVehicleIdFromStorage();
    }
    vehicleData.value = await api.vehicleData();
  }

  void _loadSentryState() async {
    String? stateFromStorage = await readStorageKey('sentryModeState');
    if (stateFromStorage != null) {
      sentryModeState.value = SentryModeState.values
          .firstWhere((element) => element.toString() == stateFromStorage);
    } else {
      setSentryState(SentryModeState.unknown);
    }

    subscriptions.add(vehicleData.listen((data) async {
      // Check Odometer if was on.
      if (sentryModeState.value == SentryModeState.on) {
        await checkOdometer(data);
      }
    }));
  }

  Future<void> checkOdometer(VehicleData? vehicleData) async {
    if (await containsStorageKey('sentryModeOnOdometer')) {
      double? lastOdometer =
          double.tryParse((await readStorageKey('sentryModeOnOdometer'))!);
      if (lastOdometer != null) {
        if (vehicleData!.vehicleState.odometer > lastOdometer) {
          setSentryState(SentryModeState.off);
        }
      }
    }
  }

  void setSentryState(SentryModeState state) {
    sentryModeState.value = state;

    writeStorageKey('sentryModeState', state.toString());
    if (state == SentryModeState.on && vehicleData.value != null) {
      writeStorageKey('sentryModeOnOdometer',
          vehicleData.value!.vehicleState.odometer.toString());
    }
  }

  setIsOnline(bool isNowOnline) {
    isOnline.value = isNowOnline;

    switch (sentryModeState.value) {
      case SentryModeState.unknown:
        if (!isNowOnline) {
          setSentryState(SentryModeState.off);
        }
        break;
      case SentryModeState.off:
        break;
      case SentryModeState.on:
        if (!isNowOnline) {
          setSentryState(SentryModeState.off);
        }
        break;
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
