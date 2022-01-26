import 'dart:async';

import 'package:deart/controllers/app_controller.dart';
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
      await _loadSentryState();
      Get.find<AppController>().isDataLoaded.value = true;
    });

    super.onReady();
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
  }

  Future _loadVehicleData() async {
    vehicleData.value = await api.vehicleData();

    vehicleData.trigger(vehicleData.value);
    // vehicleData.update((val) {
    //   // if (val != null) {
    //   //   if (Get.isRegistered<HomeController>()) {
    //   //     Get.find<HomeController>().subscribeToVehicle();
    //   //   }
    //   // }
    // });
  }

  Future _loadSentryState() async {
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
