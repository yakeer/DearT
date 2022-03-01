import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:deart/controllers/home_controller.dart';
import 'package:deart/controllers/user_controller.dart';
import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/globals.dart';
import 'package:deart/models/drive_state.dart';
import 'package:deart/models/internal/gps_location.dart';
import 'package:deart/services/auth_service.dart';
import 'package:deart/utils/siri_utils.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:deart/utils/ui_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flutter_siri_suggestions/flutter_siri_suggestions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

class SettingsController extends GetxController {
  RxBool activateSentryWhenCharging = RxBool(false);
  RxBool activateSentryWhenLocked = RxBool(false);
  RxBool sentryQuickActionToggle = RxBool(false);
  Rx<List<FlutterSiriActivity>?> siriActivities = Rx(null);
  RxBool showLogoutTeslaAccount = RxBool(false);
  RxDouble dataRefreshInterval = 0.0.obs;

  RxString appVersion = ''.obs;
  RxString carVersion = ''.obs;

  Rx<List<GPSLocation>> excludedLocations = Rx([]);
  Rx<List<SettingsTile>> excludedLocationTiles = Rx([]);

  final List<StreamSubscription> subscriptions = [];

  @override
  void onReady() async {
    if (Platform.isIOS) {
      siriActivities.value = getSiriActivities();
    }

    appVersion.value = await getAppVersion();
    getCarVersion();
    initPreferences();
    initExcludedLocations();
    super.onReady();
  }

  Future initShowTeslaLogout() async {
    String? isTeslaAccountValue = await readStorageKey('isTeslaAccount');
    if (isTeslaAccountValue == null) {
      showLogoutTeslaAccount.value = true;
    } else {
      if (isTeslaAccountValue == "true") {
        showLogoutTeslaAccount.value = true;
      } else {
        showLogoutTeslaAccount.value = false;
      }
    }
  }

  void logoutTeslaAccount() async {
    writeStorageKey('isTeslaAccount', false.toString());
    Get.toNamed('/tesla-logout');
  }

  void logout() async {
    String? isTeslaAccountValue = await readStorageKey('isTeslaAccount');
    if (isTeslaAccountValue != null) {
      if (isTeslaAccountValue == "true") {
        Get.toNamed('/logout');
      } else {
        await Get.find<AuthService>().logout();
      }
    } else {
      await Get.find<AuthService>().logout();
    }
  }

  void getCarVersion() {
    subscriptions.add(
      Get.find<VehicleController>().vehicleData.listenAndPump(
        (eventData) {
          if (eventData != null) {
            carVersion.value = eventData.vehicleState.carVersion.split(' ')[0];
          }
        },
      ),
    );
  }

  void initExcludedLocations() {
    subscriptions.add(
      Get.find<UserController>().excludedAutoSentryLocations.listenAndPump(
        (locations) {
          excludedLocations.value = locations;

          DriveState driveState =
              Get.find<VehicleController>().vehicleData.value!.driveState;

          excludedLocationTiles.value = locations
              .map(
                (data) => SettingsTile(
                  title:
                      '${data.name} (${Geolocator.distanceBetween(data.latitude, data.longitude, driveState.latitude, driveState.longitude)}m away)',
                  onPressed: (context) =>
                      Get.toNamed('/edit-location/${data.id}'),
                ),
              )
              .toList();
        },
      ),
    );
  }

  void initPreferences() {
    subscriptions.add(
      Get.find<UserController>().preferences.listenAndPump(
        (prefs) {
          activateSentryWhenCharging.value = prefs
              .firstWhere((element) => element.name == 'activateSentry')
              .value as bool;

          activateSentryWhenLocked.value = prefs
              .firstWhere(
                  (element) => element.name == 'activateSentryWhenLocked')
              .value as bool;

          sentryQuickActionToggle.value = prefs
              .firstWhere(
                  (element) => element.name == 'sentryQuickActionToggle')
              .value as bool;

          dataRefreshInterval.value = prefs
              .firstWhere((element) => element.name == 'dataRefreshInterval')
              .value as double;
        },
      ),
    );
  }

  Future changeToggle(
    String prefName,
    RxBool toggleVariable,
    bool value, {
    RxBool? refVariableInHomeScreen,
  }) async {
    int vehicleId = Get.find<VehicleController>().vehicleId.value!;

    Get.find<UserController>().setPreference(prefName, value);

    await writePreference(vehicleId, prefName, value);

    toggleVariable.value = value;

    if (refVariableInHomeScreen != null) {
      refVariableInHomeScreen.value = value;
    }
  }

  Future updateRefreshInterval(double value) async {
    dataRefreshInterval.value = value;

    Get.find<UserController>().setPreference('dataRefreshInterval', value);

    await writePreference(
      Get.find<VehicleController>().vehicleId.value!,
      'dataRefreshInterval',
      value,
    );

    Get.find<HomeController>().initRefreshDataTimer();
  }

  String getRefreshSliderText() {
    if (dataRefreshInterval.value == 0) {
      return 'Never';
    } else {
      return '${dataRefreshInterval.value} sec';
    }
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appVersion = 'V${packageInfo.version} (${packageInfo.buildNumber})';

    return appVersion;
  }

  Future copyAccessToken() async {
    await Clipboard.setData(ClipboardData(text: Globals.apiAccessToken));
    openSnackbar('Access Token', 'Copied to clipboard');
  }

  Future copyRefreshToken() async {
    await Clipboard.setData(ClipboardData(text: Globals.apiRefreshToken));
    openSnackbar('Refresh Token', 'Copied to clipboard');
  }

  Future copyVehicleData() async {
    Map<String, dynamic> vehicleDataJsonData =
        Get.find<VehicleController>().vehicleData.toJson();
    String vehicleDataJson = jsonEncode(vehicleDataJsonData);

    await Clipboard.setData(ClipboardData(text: vehicleDataJson));
    openSnackbar('Vehicle Data', 'Copied to clipboard');
  }

  Future<void> installSiriShortcut(FlutterSiriActivity activity) async {
    await FlutterSiriSuggestions.instance.buildActivity(activity);
  }

  Future<void> addCurrentVehicleLocation() async {
    String? locationName = await openPrompt('Enter Location Name');
    if (locationName != null) {
      DriveState driveState =
          Get.find<VehicleController>().vehicleData.value!.driveState;

      GPSLocation location = GPSLocation(
        const Uuid().v4(),
        driveState.latitude,
        driveState.longitude,
        locationName,
      );

      Get.find<UserController>().addAutoSentryExcludedLocation(location);
    }
  }

  Future? goToPurchases() {
    return Get.toNamed('/purchases');
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
