import 'dart:async';

import 'package:deart/controllers/user_controller.dart';
import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/controllers/work_flow_controller.dart';
import 'package:deart/models/enums/sentry_mode_state.dart';
import 'package:deart/models/internal/work_flow_preset.dart';
import 'package:deart/models/vehicle.dart';
import 'package:deart/screens/climate_page.dart';
import 'package:deart/screens/settings.dart';
import 'package:deart/screens/vehicle_page.dart';
import 'package:deart/services/tesla_api.dart';
import 'package:deart/utils/ui_utils.dart';
import 'package:deart/utils/unit_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_siri_suggestions/flutter_siri_suggestions.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:quick_actions/quick_actions.dart';

class HomeController extends GetxController {
  TeslaAPI api = Get.find<TeslaAPI>();
  Rx<int?> vehicleId = Rx(null);
  RxString vehicleName = ''.obs;

  RxBool isInitialDataLoaded = false.obs;
  RxBool refreshingVehicleData = false.obs;

  Rx<SentryModeState> sentryModeState = Rx(SentryModeState.unknown);
  RxString sentryModeStateText = 'Unknown'.obs;

  RxBool carLocked = false.obs;
  Rx<List<Vehicle>?> vehicles = Rx(null);

  // Indications
  RxDouble insideTemperature = 0.0.obs;
  RxDouble outsideTemperature = 0.0.obs;
  RxDouble batteryRange = 0.0.obs;

  RxBool isTrunkOpen = false.obs;
  RxBool isFrunkOpen = false.obs;

  RxInt batteryLevel = 0.obs;
  RxBool isChargePortOpen = false.obs;
  RxBool isChargerPluggedIn = false.obs;
  RxBool isCharging = false.obs;
  RxBool isChargerLocked = false.obs;
  Rx<int?> chargingCurrent = Rx(null);
  Rx<int?> chargingCurrentMax = Rx(null);
  RxDouble timeToFullCharge = 0.0.obs;
  RxBool canChargeMore = false.obs;
  RxInt chargeLimitSoc = 0.obs;

  RxBool isFrontDriverWindowOpen = false.obs;
  RxBool isFrontDriverDoorOpen = false.obs;
  RxBool isFrontPassengerWindowOpen = false.obs;
  RxBool isFrontPassengerDoorOpen = false.obs;
  RxBool isRearDriverWindowOpen = false.obs;
  RxBool isRearDriverDoorOpen = false.obs;
  RxBool isRearPassengerWindowOpen = false.obs;
  RxBool isRearPassengerDoorOpen = false.obs;

  // Climate
  RxDouble acTemperatureCurrent = 20.0.obs;
  RxDouble acTemperatureSet = 20.0.obs;
  RxInt acTemperatureSetInt = 40.obs;
  RxDouble acMinTemperatureAvailable = 15.0.obs;
  RxDouble acMaxTemperatureAvailable = 28.0.obs;
  RxBool isClimateOn = false.obs;
  RxBool isPreconditioning = false.obs;

  // Pages Slide
  PageController pageController = PageController(initialPage: 0);
  RxInt selectedPage = 0.obs;
  List<Widget> pages = const [VehiclePage(), ClimatePage(), SettingsScreen()];

  // Battery Widget
  RxBool showBatteryLevel = RxBool(false);

  // Heaters
  Rx<bool?> isStreeringWheelHeaterOn = Rx(null);
  Rx<int?> seatHeaterLeft = Rx(null);
  Rx<int?> seatHeaterRight = Rx(null);
  Rx<int?> seatHeaterRearLeft = Rx(null);
  Rx<int?> seatHeaterRearCenter = Rx(null);
  Rx<int?> seatHeaterRearRight = Rx(null);
  RxBool hasRearSeatHeaters = false.obs;

  final List<StreamSubscription> subscriptions = [];
  SnackbarController? snackBar;

  @override
  void onInit() {
    Get.find<UserController>().vehicles.listenAndPump((data) {
      if (data != null) {
        vehicles.value = data;
      }
    });

    subscribeToVehicle();

    initQuickActions();

    initPreferences();

    initSiriShortcuts();

    super.onInit();
  }

  void initPreferences() {
    showBatteryLevel.value = Get.find<UserController>()
        .getPreference<bool>('showBatteryLevelInAppBar')!;
  }

  Future<void> initSiriShortcuts() async {
    // Awaken from Siri Suggestion
    FlutterSiriSuggestions.instance.configure(
        onLaunch: (Map<String, dynamic> message) async {
      // message = {title: "Open App", key: "mainActivity", userInfo: {}}
      // Do what you want :)
      if (message.isNotEmpty) {
        refreshState();

        switch (message["key"]) {
          case "horn":
            await horn();
            break;
          case "sentryOn":
            await turnOnSentry();
            break;
          case "sentryOff":
            await turnOnSentry();
            break;
          case "unlockDoors":
            await unlock();
            break;
          case "lockDoors":
            await lock();
            break;
          case "openChargePort":
            await openChargePort();
            break;
          case "closeChargePort":
            await closeChargePort();
            break;
          case "unlockCharger":
            await unlockCharger();
            break;
          case "startCharging":
            await startCharging();
            break;
          case "stopCharging":
            await stopCharging();
            break;
          case "ventWindows":
            await ventWindows();
            break;
          case "closeWindows":
            await closeWindows();
            break;
          case "defrostCar":
            await turnOnMaxDefrost();
            break;
          case "defrostCarOff":
            await turnOffMaxDefrost();
            break;
          default:
            break;
        }
      }
    });
  }

  void initQuickActions() {
    const QuickActions quickActions = QuickActions();

    quickActions.initialize((shortcutType) async {
      await refreshState();

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
        case 'toggle_charge_port':
          await toggleChargePort();
          break;
      }
    });

    quickActions.setShortcutItems(
      <ShortcutItem>[
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
        ),
        const ShortcutItem(
          type: 'toggle_charge_port',
          localizedTitle: 'Toggle Charge Port',
        ),
      ],
    );
  }

  String cleanName(String rawValue) {
    String result = HtmlUnescape().convert(rawValue);
    result = result.replaceAll(r'&#34;', '"');
    result = result.replaceAll(r'&#39;', '\'');

    return result;
  }

  void subscribeToVehicle() async {
    subscriptions.add(Get.find<VehicleController>()
        .refreshingVehicleData
        .listenAndPump((isRefreshing) {
      refreshingVehicleData.value = isRefreshing;
    }));

    subscriptions.add(
      Get.find<VehicleController>().isOnline.listenAndPump(
        (value) {
          if (value != null && value == true) {
            if (!isInitialDataLoaded.value) {
              isInitialDataLoaded.value = true;
            }
          }
        },
      ),
    );

    subscriptions.add(
      Get.find<UserController>().selectedVehicle.listenAndPump((data) {
        if (data != null) {
          vehicleId.value = data.id;
          vehicleName.value = cleanName(data.displayName);
        }
      }),
    );

    subscriptions.add(
      Get.find<VehicleController>().vehicleData.listenAndPump((vehicleData) {
        if (vehicleData != null) {
          if (!isInitialDataLoaded.value) {
            isInitialDataLoaded.value = true;
          }

          // Refresh Sentry State
          Get.find<VehicleController>().loadSentryState(vehicleData);

          batteryLevel.value = vehicleData.chargeState.batteryLevel;
          batteryRange.value = mileToKM(vehicleData.chargeState.batteryRange);

          insideTemperature.value = vehicleData.climateState.insideTemp;
          outsideTemperature.value = vehicleData.climateState.outsideTemp;

          carLocked.value = vehicleData.vehicleState.locked;

          // Doors + Trunks + Windows
          isFrunkOpen.value = vehicleData.vehicleState.frontTrunk > 0;
          isTrunkOpen.value = vehicleData.vehicleState.rearTrunk > 0;
          isFrontDriverDoorOpen.value =
              vehicleData.vehicleState.frontDriverDoor > 0;
          isFrontDriverWindowOpen.value =
              vehicleData.vehicleState.frontDriverWindow > 0;
          isFrontPassengerDoorOpen.value =
              vehicleData.vehicleState.frontPassengerDoor > 0;
          isFrontPassengerWindowOpen.value =
              vehicleData.vehicleState.frontPassengerWindow > 0;
          isRearDriverDoorOpen.value =
              vehicleData.vehicleState.rearDriverDoor > 0;
          isRearDriverWindowOpen.value =
              vehicleData.vehicleState.rearDriverWindow > 0;
          isRearPassengerDoorOpen.value =
              vehicleData.vehicleState.rearPassengerDoor > 0;
          isRearPassengerWindowOpen.value =
              vehicleData.vehicleState.rearPassengerWindow > 0;

          // Charging
          isChargePortOpen.value = vehicleData.chargeState.chargePortDoorOpen;
          if (vehicleData.chargeState.chargePortDoorOpen &&
              vehicleData.chargeState.chargePortLatch == 'Engaged') {
            isChargerPluggedIn.value = true;
          } else {
            isChargerPluggedIn.value = false;
          }

          if (isChargerPluggedIn.value &&
              vehicleData.chargeState.chargingState == "Charging") {
            isCharging.value = true;
          } else {
            isCharging.value = false;
          }

          if (isChargerPluggedIn.value &&
              vehicleData.chargeState.chargePortLatch == 'Engaged') {
            isChargerLocked.value = true;
          } else {
            isChargerLocked.value = false;
          }

          chargeLimitSoc.value = vehicleData.chargeState.chargeLimitSoc;
          if (batteryLevel.value >= chargeLimitSoc.value) {
            canChargeMore.value = false;
          } else {
            canChargeMore.value = true;
          }

          chargingCurrent.value = vehicleData.chargeState.chargerActualCurrent;
          chargingCurrentMax.value =
              vehicleData.chargeState.chargeCurrentRequestMax;

          timeToFullCharge.value = vehicleData.chargeState.timeToFullCharge;

          // AC
          acTemperatureCurrent.value =
              vehicleData.climateState.driverTempSetting;
          acTemperatureSet.value = acTemperatureCurrent.value;

          acMinTemperatureAvailable.value =
              vehicleData.climateState.minAvailableTemp;

          acMaxTemperatureAvailable.value =
              vehicleData.climateState.maxAvailableTemp;

          acTemperatureSetInt.value =
              (acTemperatureCurrent.value * 2.0).toInt();

          isClimateOn.value = vehicleData.climateState.isClimateOn;

          isPreconditioning.value = vehicleData.climateState.isPreconditioning;

          // Heaters
          hasRearSeatHeaters.value =
              vehicleData.vehicleConfig.rearSeatHeaters > 0;
          isStreeringWheelHeaterOn.value =
              vehicleData.climateState.steeringWheelHeater;
          seatHeaterLeft.value = vehicleData.climateState.seatHeaterLeft;
          seatHeaterRight.value = vehicleData.climateState.seatHeaterRight;
          seatHeaterRearLeft.value =
              vehicleData.climateState.seatHeaterRearLeft;
          seatHeaterRearCenter.value =
              vehicleData.climateState.seatHeaterRearCenter;
          seatHeaterRearRight.value =
              vehicleData.climateState.seatHeaterRearRight;
        }
      }),
    );

    subscriptions.add(
      Get.find<VehicleController>()
          .sentryModeState
          .listenAndPump((sentryModeState) {
        this.sentryModeState.value = sentryModeState;
        sentryModeStateText.value = getSentryModeStateText(sentryModeState);
      }),
    );
  }

  bool anyDoorOpen() {
    if (isFrontDriverDoorOpen.value ||
        isFrontPassengerDoorOpen.value ||
        isRearDriverDoorOpen.value ||
        isRearPassengerDoorOpen.value) {
      return true;
    } else {
      return false;
    }
  }

  bool anyWindowOpen() {
    if (isFrontDriverWindowOpen.value ||
        isFrontPassengerWindowOpen.value ||
        isRearDriverWindowOpen.value ||
        isRearPassengerWindowOpen.value) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> turnOnSentry() async {
    bool success = await Get.find<VehicleController>().toggleSentry(true);

    showCommandSnackbar(
      success,
      'Sentry Mode',
      'Activated succesfully.',
      'Failed to activate, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> turnOffSentry() async {
    bool success = await Get.find<VehicleController>().toggleSentry(false);

    showCommandSnackbar(
      success,
      'Sentry Mode',
      'Deactivated succesfully.',
      'Failed to deactivate, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> lock() async {
    carLocked.value = true;
    bool success = await Get.find<VehicleController>().doorLock();

    openSnackbar('Lock', 'Car is now locked.', currentSnackbar: snackBar);

    return success;
  }

  Future<bool> unlock() async {
    carLocked.value = false;
    bool success = await Get.find<VehicleController>().doorUnlock();

    showCommandSnackbar(
      success,
      'Unlock',
      'Car is now unlocked.',
      'Failed to unlock, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> openTrunk() async {
    bool success = await Get.find<VehicleController>().openTrunk();

    showCommandSnackbar(
      success,
      'Trunk',
      'Trunk is now opened',
      'Failed to open trunk, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> openFrunk() async {
    bool success = await Get.find<VehicleController>().openFrunk();

    showCommandSnackbar(
      success,
      'Frunk',
      'Frunk is now opened',
      'Failed to open Frunk, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> horn() async {
    bool success = await api.horn();

    showCommandSnackbar(
      success,
      'Beep Beep',
      'Don\'t disturb your neighbors!',
      'Failed to hont horn, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> flashLights() async {
    bool success = await api.flashLights();

    showCommandSnackbar(
      success,
      'Blink Blink',
      'It\'s too shiny!',
      'Failed to flash lights, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> toggleChargePort() async {
    if (isChargePortOpen.value) {
      return closeChargePort();
    } else {
      return openChargePort();
    }
  }

  Future<bool> openChargePort() async {
    bool success = await Get.find<VehicleController>().openChargePort();

    showCommandSnackbar(
      success,
      'Charge Port',
      'Charge port is now opened.',
      'Failed to open charge port, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> closeChargePort() async {
    bool success = await Get.find<VehicleController>().closeChargePort();

    showCommandSnackbar(
      success,
      'Charge Port',
      'Charge port is now closed.',
      'Failed to close charge port, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> startCharging() async {
    isCharging.value = true;

    bool success = await Get.find<VehicleController>().startCharging();

    // Get Charger Current after 5 and 10 seconds, because it takes.
    Future.delayed(const Duration(seconds: 5), () => refreshState());

    Future.delayed(const Duration(seconds: 10), () => refreshState());

    showCommandSnackbar(
      success,
      'Charging',
      'Charging started.',
      'Failed to start charging port, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> stopCharging() async {
    isCharging.value = false;

    bool success = await Get.find<VehicleController>().stopCharging();

    Future.delayed(const Duration(seconds: 5), () => refreshState());

    showCommandSnackbar(
      success,
      'Charging',
      'Charging stopped.',
      'Failed to stop charging port, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> unlockCharger() async {
    isCharging.value = false;

    bool success = await Get.find<VehicleController>().unlockCharger();

    showCommandSnackbar(
      success,
      'Charging',
      'Charging unlocked.',
      'Failed to unlock charger, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> stopChargeAndUnlock() async {
    isCharging.value = false;
    isChargerLocked.value = false;

    bool unlockSuccess = false;
    bool stopChargeSuccess = await Get.find<VehicleController>().stopCharging();
    if (stopChargeSuccess) {
      unlockSuccess = await Get.find<VehicleController>().unlockCharger();
    }

    showCommandSnackbar(
      unlockSuccess && stopChargeSuccess,
      'Charging',
      'Charging stopped & charger unlocked.',
      'Failed to stop + unlock charger, Check phone & car connectivity',
    );

    return stopChargeSuccess && unlockSuccess;
  }

  Future<bool> setACTemperature() async {
    bool success = await Get.find<VehicleController>()
        .setACTemperature(acTemperatureSet.value);

    if (success) {
      acTemperatureCurrent.value = acTemperatureSet.value;
    }

    showCommandSnackbar(
      success,
      'A/C',
      'Temperature set to ${acTemperatureSet.value}',
      'Failed to set a/c temperature, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> acStart() async {
    bool success = await Get.find<VehicleController>().acStart();

    showCommandSnackbar(
      success,
      'A/C',
      'Turned on to ${acTemperatureSet.value} C',
      'Failed to turn on a/c, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> acStop() async {
    bool success = await Get.find<VehicleController>().acStop();

    showCommandSnackbar(
      success,
      'A/C',
      'Turned off',
      'Failed to turn off a/c, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> ventWindows() async {
    bool success = await Get.find<VehicleController>().ventWindows();

    showCommandSnackbar(
      success,
      'Windows',
      'Windows are now slightly opened.',
      'Failed to vent windows, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> closeWindows() async {
    bool success = await Get.find<VehicleController>().closeWindows();

    showCommandSnackbar(
      success,
      'Windows',
      'Windows are now fully closed.',
      'Failed to close windows, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> turnOnMaxDefrost() async {
    bool success = await Get.find<VehicleController>().toggleMaxDefrost(true);

    showCommandSnackbar(
      success,
      'Defrost',
      'Activated succesfully.',
      'Failed to activate defrost, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> turnOffMaxDefrost() async {
    bool success = await Get.find<VehicleController>().toggleMaxDefrost(false);

    showCommandSnackbar(
      success,
      'Defrost',
      'Deactivated succesfully.',
      'Failed to deactivate defrost, Check phone & car connectivity',
    );

    return success;
  }

  Future<bool> toggleSteeringWheelHeater({bool turnOff = false}) async {
    bool success = true;
    if (isStreeringWheelHeaterOn.value != null) {
      if (isClimateOn.value == false) {
        await Get.find<VehicleController>().acStart();
      }

      if (turnOff) {
        if (isStreeringWheelHeaterOn.value!) {
          success = await Get.find<VehicleController>()
              .toggleSteeringWheelHeater(false);
        }
      } else {
        success = await Get.find<VehicleController>()
            .toggleSteeringWheelHeater(!isStreeringWheelHeaterOn.value!);
      }

      // if (!turnOff) {
      //   if (isStreeringWheelHeaterOn.value!) {
      //     openSnackbar(
      //       'Steering Wheel Heater',
      //       'turned off.',
      //       currentSnackbar: snackBar,
      //     );
      //   } else {
      //     openSnackbar(
      //       'Steering Wheel Heater',
      //       'turned on.',
      //       currentSnackbar: snackBar,
      //     );
      //   }
      // }
    }

    return success;
  }

  Future<bool> toggleSeatHeader(int seatNumber, Rx<int?> seatObservable,
      {bool toggleMax = false, toggleOff = false}) async {
    // Seats:
    // 0 - Front Left
    // 1 - Front right
    // 2 - Rear left
    // 4 - Rear center
    // 5 - Rear right
    bool success = true;
    if (seatObservable.value != null) {
      int activateLevel = seatObservable.value! + 1;
      if (activateLevel > 3) {
        activateLevel = 0;
      }

      if (toggleMax) {
        activateLevel = 3;
      }

      if (toggleOff) {
        activateLevel = 0;
      }

      seatObservable.value = activateLevel;

      if (isClimateOn.value == false) {
        await Get.find<VehicleController>().acStart();
      }

      success = await Get.find<VehicleController>()
          .toggleSeatHeater(seatNumber, activateLevel);

      // if (activateLevel == 0) {
      //   openSnackbar(
      //     'Seat $seatNumber',
      //     'turned off.',
      //     currentSnackbar: snackBar,
      //   );
      // } else {
      //   openSnackbar(
      //     'Seat $seatNumber',
      //     'heated to level $activateLevel.',
      //     currentSnackbar: snackBar,
      //   );
      // }
    }

    return success;
  }

  Future<bool> startWorkFlow(WorkFlowPreset preset) async {
    if (Get.isRegistered<VehicleController>() &&
        Get.isRegistered<WorkFlowController>()) {
      bool success =
          await Get.find<WorkFlowController>().startWorkFlow(preset: preset);

      showCommandSnackbar(
        success,
        'WorkFlow',
        '${getWorkFlowName(preset)} finished successfully.',
        '${getWorkFlowName(preset)} workflow failed!',
      );
    }

    return false;
  }

  String getWorkFlowPopupMessage(WorkFlowPreset preset) {
    switch (preset) {
      case WorkFlowPreset.preheat:
        return "- Heats driver's seat\n- Heats steering wheel\n- Turn A/C to 25 degress.\n- Stops Charging\n- Unlocks charger port";
      case WorkFlowPreset.precool:
        return "- Stop driver's seat heat\n- Stops steering wheel heating\n- Turn A/C to 19 degress.\n- Vents windows for 1 minute.\n- Stops Charging\n- Unlocks charger port";
      case WorkFlowPreset.findMyCar:
        return "Flashes 2 times,\nwaits 5 seconds and flashes 2 times again.\nAfter 10 seconds, honks horn, and flashes 5 times.";
    }
  }

  String getWorkFlowName(WorkFlowPreset preset) {
    switch (preset) {
      case WorkFlowPreset.preheat:
        return 'Preheat';
      case WorkFlowPreset.precool:
        return 'Precool';
      case WorkFlowPreset.findMyCar:
        return 'Find My Car';
    }
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

  String getDurationString(double hoursDuration) {
    Duration duration = Duration(minutes: (hoursDuration * 60).toInt());

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}h ${twoDigitMinutes}m";
  }

  String getFinishTime(double hoursDuration) {
    Duration duration = Duration(minutes: (hoursDuration * 60).toInt());
    DateTime finishTime = DateTime.now().add(duration);
    return DateFormat.Hm().format(finishTime);
  }

  Future refreshState() async {
    await Get.find<VehicleController>().refreshState(false);
  }

  void onPageChanged(int pageNumber) {
    selectedPage.value = pageNumber;
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
