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
import 'package:deart/utils/tesla_api.dart';
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
              vehicleData.chargeState.chargePortLatch == 'Engaged' &&
              (vehicleData.chargeState.chargerPilotCurrent != null &&
                  vehicleData.chargeState.chargerPilotCurrent! > 0)) {
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

    openSnackbar('Sentry Mode', 'Activated succesfully.',
        currentSnackbar: snackBar);

    return success;
  }

  Future<bool> turnOffSentry() async {
    bool success = await Get.find<VehicleController>().toggleSentry(false);

    openSnackbar(
      'Sentry Mode',
      'Deactivated succesfully.',
      currentSnackbar: snackBar,
    );

    return success;
  }

  Future<bool> lock() async {
    bool success = await Get.find<VehicleController>().doorLock();

    openSnackbar('Lock', 'Car is now locked.', currentSnackbar: snackBar);

    return success;
  }

  Future<bool> unlock() async {
    openSnackbar('Unlock', 'Unlocking...', currentSnackbar: snackBar);

    bool success = await Get.find<VehicleController>().doorUnlock();

    openSnackbar('Unlock', 'Car is now unlocked.', currentSnackbar: snackBar);

    return success;
  }

  Future<bool> openTrunk() async {
    openSnackbar('Trunk', 'Opening...', currentSnackbar: snackBar);

    bool success = await Get.find<VehicleController>().openTrunk();

    openSnackbar('Trunk', 'Trunk is now opened.', currentSnackbar: snackBar);

    return success;
  }

  Future<bool> openFrunk() async {
    openSnackbar('Frunk', 'Opening...', currentSnackbar: snackBar);

    bool success = await Get.find<VehicleController>().openFrunk();

    openSnackbar('Frunk', 'Frunk is now opened.', currentSnackbar: snackBar);

    return success;
  }

  Future<bool> horn() async {
    bool success = await api.horn();

    openSnackbar('Beep beep', 'Don\'t disturb your neighbors!',
        currentSnackbar: snackBar);

    return success;
  }

  Future<bool> flashLights() async {
    bool success = await api.flashLights();

    openSnackbar('Blink Blink', 'It\'s too shiny!', currentSnackbar: snackBar);

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

    openSnackbar('Charge Port', 'Charge port is now opened.',
        currentSnackbar: snackBar);

    return success;
  }

  Future<bool> closeChargePort() async {
    bool success = await Get.find<VehicleController>().closeChargePort();

    openSnackbar('Charge Port', 'Charge port is now closed.',
        currentSnackbar: snackBar);

    return success;
  }

  Future<bool> startCharging() async {
    isCharging.value = true;

    bool success = await Get.find<VehicleController>().startCharging();

    // Get Charger Current after 5 and 10 seconds, because it takes.
    Future.delayed(const Duration(seconds: 5), () => refreshState());

    Future.delayed(const Duration(seconds: 10), () => refreshState());

    openSnackbar('Charging', 'Charging started.', currentSnackbar: snackBar);

    return success;
  }

  Future<bool> stopCharging() async {
    isCharging.value = false;

    bool success = await Get.find<VehicleController>().stopCharging();

    Future.delayed(const Duration(seconds: 5), () => refreshState());

    openSnackbar('Charging', 'Charging stopped.', currentSnackbar: snackBar);

    return success;
  }

  Future<bool> unlockCharger() async {
    isCharging.value = false;

    bool success = await Get.find<VehicleController>().unlockCharger();

    openSnackbar('Charging', 'Charger unlocked.', currentSnackbar: snackBar);

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

    openSnackbar('Charging Stopped', 'Charger unlocked.',
        currentSnackbar: snackBar);

    return stopChargeSuccess && unlockSuccess;
  }

  Future<bool> setACTemperature() async {
    bool success = await Get.find<VehicleController>()
        .setACTemperature(acTemperatureSet.value);

    if (success) {
      acTemperatureCurrent.value = acTemperatureSet.value;
    }

    openSnackbar(
      'A/C',
      'Temperature set to ${acTemperatureSet.value}',
      currentSnackbar: snackBar,
    );

    return success;
  }

  Future<bool> acStart() async {
    bool success = await Get.find<VehicleController>().acStart();

    openSnackbar(
      'A/C',
      'Turned on to ${acTemperatureSet.value} C',
      currentSnackbar: snackBar,
    );

    return success;
  }

  Future<bool> acStop() async {
    bool success = await Get.find<VehicleController>().acStop();

    openSnackbar(
      'A/C',
      'Turned off',
      currentSnackbar: snackBar,
    );

    return success;
  }

  Future<bool> ventWindows() async {
    bool success = await Get.find<VehicleController>().ventWindows();

    openSnackbar(
      'Windows',
      'Windows are now slightly opened.',
      currentSnackbar: snackBar,
    );

    return success;
  }

  Future<bool> closeWindows() async {
    bool success = await Get.find<VehicleController>().closeWindows();

    openSnackbar(
      'Windows',
      'Windows are now fully closed.',
      currentSnackbar: snackBar,
    );

    return success;
  }

  Future<bool> turnOnMaxDefrost() async {
    openSnackbar('Defrost', 'Activating...');

    bool success = await Get.find<VehicleController>().toggleMaxDefrost(true);

    openSnackbar('Defrost', 'Activated succesfully.',
        currentSnackbar: snackBar);

    return success;
  }

  Future<bool> turnOffMaxDefrost() async {
    openSnackbar('Defrost', 'Activating...');

    bool success = await Get.find<VehicleController>().toggleMaxDefrost(false);

    openSnackbar('Defrost', 'Deactivated succesfully.',
        currentSnackbar: snackBar);

    return success;
  }

  Future<bool> startWorkFlow(WorkFlowPreset preset) async {
    if (Get.isRegistered<VehicleController>() &&
        Get.isRegistered<WorkFlowController>()) {
      bool success =
          await Get.find<WorkFlowController>().startWorkFlow(preset: preset);

      if (success) {
        openSnackbar(
          'WorkFlow',
          '${getWorkFlowName(preset)} finished successfully.',
          currentSnackbar: snackBar,
        );
      } else {
        openSnackbar(
          'WorkFlow',
          '${getWorkFlowName(preset)} workflow failed!',
          currentSnackbar: snackBar,
        );
      }
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
    await Get.find<VehicleController>().refreshState();
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
