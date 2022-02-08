import 'dart:async';
import 'dart:io';

import 'package:deart/controllers/user_controller.dart';
import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/globals.dart';
import 'package:deart/services/auth_service.dart';
import 'package:deart/utils/siri_utils.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:deart/utils/ui_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_siri_suggestions/flutter_siri_suggestions.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsController extends GetxController {
  RxBool activateSentryWhenCharging = RxBool(false);
  RxBool showBatteryLevelInAppBar = RxBool(false);
  Rx<List<FlutterSiriActivity>?> siriActivities = Rx(null);
  RxBool showLogoutTeslaAccount = RxBool(false);

  RxString appVersion = ''.obs;
  RxString carVersion = ''.obs;

  final List<StreamSubscription> subscriptions = [];

  @override
  void onReady() async {
    if (Platform.isIOS) {
      siriActivities.value = getSiriActivities();
    }

    appVersion.value = await getAppVersion();
    getCarVersion();
    initPreferences();
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

  void initPreferences() {
    subscriptions.add(
      Get.find<UserController>().preferences.listenAndPump(
        (prefs) {
          activateSentryWhenCharging.value = prefs
              .firstWhere((element) => element.name == 'activateSentry')
              .value as bool;

          showBatteryLevelInAppBar.value = prefs
              .firstWhere(
                  (element) => element.name == 'showBatteryLevelInAppBar')
              .value as bool;
        },
      ),
    );
  }

  changeToggle(String prefName, RxBool toggleVariable, bool value) async {
    int vehicleId = Get.find<VehicleController>().vehicleId.value!;

    Get.find<UserController>().setPreference(prefName, value);

    await writePreference(vehicleId, prefName, value);

    toggleVariable.value = value;

    // initPreferences();
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

  Future<void> installSiriShortcut(FlutterSiriActivity activity) async {
    await FlutterSiriSuggestions.instance.buildActivity(activity);
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
