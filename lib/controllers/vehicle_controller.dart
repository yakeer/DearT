import 'dart:async';

import 'package:deart/controllers/app_controller.dart';
import 'package:deart/controllers/user_controller.dart';
import 'package:deart/models/enums/sentry_mode_state.dart';
import 'package:deart/models/vehicle.dart';
import 'package:deart/models/vehicle_data.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:deart/utils/tesla_api.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';

class VehicleController extends GetxController {
  Rx<int?> vehicleId = Rx(null);
  RxString vehicleName = RxString('N/A');
  Rx<SentryModeState> sentryModeState = Rx(SentryModeState.unknown);
  Rx<VehicleData?> vehicleData = Rx(null);
  Rx<bool?> isOnline = Rx(null);

  TeslaAPI api = Get.find<TeslaAPI>();

  final List<StreamSubscription> subscriptions = [];

  VehicleController(int? vehicleId, {Vehicle? vehicle}) : super() {
    this.vehicleId.value = vehicleId;
    if (vehicle != null) {
      setVehicleParameters(vehicle);
    }
  }

  @override
  void onReady() async {
    _loadVehicleData().then((value) async {
      // if (value != null) {
      //   await loadSentryState(value);

      //   performAutomations(value);
      // }

      Get.find<AppController>().isDataLoaded.value = true;
    });

    super.onReady();
  }

  Future performAutomations(VehicleData vehicleData) async {
    // Check if car is charging
    if (vehicleData.chargeState.chargingState == "Charging") {
      if (Get.find<UserController>().getPreference<bool>('activateSentry') ??
          false) {
        if (sentryModeState.value != SentryModeState.on) {
          await toggleSentry(true);
        }
      }
    }
  }

  void changeVehicle(int vehicleId, String vehicleName) {
    this.vehicleId.value = vehicleId;
    this.vehicleName.value = vehicleName;
  }

  void setVehicleParameters(Vehicle vehicle) {
    vehicleId.value = vehicle.id;
    vehicleName.value = HtmlUnescape().convert(
      vehicle.displayName,
    );
    isOnline.value = vehicle.state == "online";
  }

  Future _loadVehicleData() async {
    vehicleData.value = await api.vehicleData();
    if (vehicleData.value != null) {
      await loadSentryState(vehicleData.value!);

      performAutomations(vehicleData.value!);
    }

    vehicleData.trigger(vehicleData.value);
  }

  Future loadSentryState(VehicleData vehicleData) async {
    String? stateFromStorage = await readStorageKey('sentryModeState');
    if (stateFromStorage != null) {
      sentryModeState.value = SentryModeState.values
          .firstWhere((element) => element.toString() == stateFromStorage);
    } else {
      // If the car is not online, and this is the first time we try to determine,
      // then sentry must be off in this situation. because sentry keeps the car online.
      if (isOnline.value != null && !isOnline.value!) {
        setSentryState(SentryModeState.off);
      } else {
        setSentryState(SentryModeState.unknown);
      }
    }

    if (sentryModeState.value == SentryModeState.on) {
      await checkOdometer(vehicleData);
    }
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

  Future toggleSentry(bool activate) async {
    bool success = await api.toggleSentry(activate);

    if (success) {
      if (activate) {
        setSentryState(SentryModeState.on);
      } else {
        setSentryState(SentryModeState.off);
      }
    } else {
      setSentryState(SentryModeState.unknown);
    }
  }

  Future<bool> horn() async {
    return await api.horn();
  }

  Future<bool> flashLights() async {
    return await api.flashLights();
  }

  Future<bool> doorLock() async {
    bool success = await api.doorLock(vehicleId.value!);

    await _loadVehicleData();

    return success;
  }

  Future<bool> doorUnlock() async {
    bool success = await api.doorUnlock(vehicleId.value!);

    await _loadVehicleData();

    return success;
  }

  Future<bool> openTrunk() async {
    bool success = await api.openTrunk(vehicleId.value!);

    await _loadVehicleData();

    return success;
  }

  Future<bool> openFrunk() async {
    bool success = await api.openFrunk(vehicleId.value!);

    await _loadVehicleData();

    return success;
  }

  Future<bool> openChargePort() async {
    bool success = await api.openChargePort(vehicleId.value!);

    Future.delayed(
      const Duration(seconds: 1),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> closeChargePort() async {
    bool success = await api.closeChargePort(vehicleId.value!);

    Future.delayed(
      const Duration(seconds: 1),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> startCharging() async {
    bool success = await api.startCharging(vehicleId.value!);

    Future.delayed(
      const Duration(seconds: 3),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> stopCharging() async {
    bool success = await api.stopCharging(vehicleId.value!);

    Future.delayed(
      const Duration(seconds: 3),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> unlockCharger() async {
    bool success = await api.unlockCharger(vehicleId.value!);

    Future.delayed(
      const Duration(seconds: 1),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future refreshState() async {
    return _loadVehicleData();
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
