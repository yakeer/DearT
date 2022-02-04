import 'dart:async';

import 'package:deart/controllers/app_controller.dart';
import 'package:deart/controllers/user_controller.dart';
import 'package:deart/models/enums/car_model.dart';
import 'package:deart/models/enums/sentry_mode_state.dart';
import 'package:deart/models/vehicle.dart';
import 'package:deart/models/vehicle_config.dart';
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
  Rx<CarModel> carModel = Rx(CarModel.model3WhiteBlack);
  RxDouble acTemperatureSet = 0.0.obs;
  RxDouble carLongitude = 0.0.obs;
  RxDouble carLatitude = 0.0.obs;
  Rx<int?> streamingVehicleId = Rx(null);

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

  Future getCarLocation(VehicleData vehicleData) async {
    carLongitude.value = vehicleData.driveState.longitude;
    carLatitude.value = vehicleData.driveState.latitude;
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

    streamingVehicleId.value = vehicle.vehicleId;
  }

  Future _loadVehicleData() async {
    vehicleData.value = await api.vehicleData();
    if (vehicleData.value != null) {
      await loadSentryState(vehicleData.value!);

      performAutomations(vehicleData.value!);

      getCarLocation(vehicleData.value!);

      _loadCarModel(vehicleData.value!.vehicleConfig);
    }

    vehicleData.trigger(vehicleData.value);
  }

  Future<void> _loadCarModel(VehicleConfig vehicleConfig) {
    if (vehicleConfig.exteriorColor.contains('Black')) {
      if (vehicleConfig.interiorTrimType.contains('White')) {
        carModel.value = CarModel.model3BlackWhite;
      } else {
        carModel.value = CarModel.model3BlackBlack;
      }
    } else if (vehicleConfig.exteriorColor.contains('Blue')) {
      if (vehicleConfig.interiorTrimType.contains('White')) {
        carModel.value = CarModel.model3BlueWhite;
      } else {
        carModel.value = CarModel.model3BlueBlack;
      }
    } else if (vehicleConfig.exteriorColor.contains('MidnightSilver')) {
      if (vehicleConfig.interiorTrimType.contains('White')) {
        carModel.value = CarModel.model3GrayWhite;
      } else {
        carModel.value = CarModel.model3GrayBlack;
      }
    } else if (vehicleConfig.exteriorColor.contains('Red')) {
      if (vehicleConfig.interiorTrimType.contains('White')) {
        carModel.value = CarModel.model3RedWhite;
      } else {
        carModel.value = CarModel.model3RedBlack;
      }
    } else if (vehicleConfig.exteriorColor.contains('White')) {
      if (vehicleConfig.interiorTrimType.contains('White')) {
        carModel.value = CarModel.model3WhiteWhite;
      } else {
        carModel.value = CarModel.model3WhiteBlack;
      }
    } else {
      carModel.value = CarModel.model3WhiteBlack;
    }

    return Future.value();
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

  Future<bool> toggleSentry(bool activate) async {
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

    return success;
  }

  Future<bool> horn() async {
    return await api.horn();
  }

  Future<bool> flashLights() async {
    return await api.flashLights();
  }

  Future<bool> doorLock() async {
    bool success = await api.doorLock(vehicleId.value!);

    Future.delayed(
      const Duration(seconds: 1),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> doorUnlock() async {
    bool success = await api.doorUnlock(vehicleId.value!);

    Future.delayed(
      const Duration(seconds: 1),
      () async => await _loadVehicleData(),
    );

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

    await Future.delayed(
      const Duration(seconds: 1),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> closeChargePort() async {
    bool success = await api.closeChargePort(vehicleId.value!);

    await Future.delayed(
      const Duration(seconds: 1),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> startCharging() async {
    bool success = await api.startCharging(vehicleId.value!);

    await Future.delayed(
      const Duration(seconds: 1),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> stopCharging() async {
    bool success = await api.stopCharging(vehicleId.value!);

    await Future.delayed(
      const Duration(seconds: 1),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> unlockCharger() async {
    bool success = await api.unlockCharger(vehicleId.value!);

    await Future.delayed(
      const Duration(seconds: 1),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> setACTemperature(double temperature) async {
    bool success = await api.setACTemperature(
      vehicleId.value!,
      temperature,
    );

    Future.delayed(
      const Duration(seconds: 3),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> acStart() async {
    bool success = await api.acStart(
      vehicleId.value!,
    );

    await Future.delayed(
      const Duration(seconds: 1),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> acStop() async {
    bool success = await api.acStop(
      vehicleId.value!,
    );

    await Future.delayed(
      const Duration(seconds: 1),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> toggleSteeringWheelHeater(bool setOn) async {
    bool success = await api.toggleSteeringWheelHeater(
      vehicleId.value!,
      setOn,
    );

    Future.delayed(
      const Duration(seconds: 3),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> toggleSeatHeater(int seatNumber, int level) async {
    bool success = await api.toggleSeatHeater(
      vehicleId.value!,
      seatNumber,
      level,
    );

    Future.delayed(
      const Duration(seconds: 3),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> ventWindows() async {
    bool success = await api.ventWindows(
      vehicleId.value!,
    );

    await Future.delayed(
      const Duration(seconds: 1),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> closeWindows() async {
    bool success = await api.closeWindows(
      vehicleId.value!,
      carLongitude.value,
      carLatitude.value,
    );

    await Future.delayed(
      const Duration(seconds: 1),
      () async => await _loadVehicleData(),
    );

    return success;
  }

  Future<bool> toggleMaxDefrost(bool setOn) async {
    bool success = await api.maxDefrost(
      vehicleId.value!,
      setOn,
    );

    await Future.delayed(
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
