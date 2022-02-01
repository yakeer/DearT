import 'dart:async';

import 'package:deart/controllers/user_controller.dart';
import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/globals.dart';
import 'package:deart/services/auth_service.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:deart/utils/ui_utils.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsController extends GetxController {
  RxBool activateSentryWhenCharging = RxBool(false);
  RxString appVersion = ''.obs;
  RxString carVersion = ''.obs;

  final List<StreamSubscription> subscriptions = [];

  @override
  void onReady() async {
    appVersion.value = await getAppVersion();
    getCarVersion();
    initPreferences();
    super.onReady();
  }

  void logout() async {
    await Get.find<AuthService>().logout();

    Get.offAllNamed('/');
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
        },
      ),
    );
  }

  changeToggle(String prefName, RxBool toggleVariable, bool value) async {
    toggleVariable.value = value;

    int vehicleId = Get.find<VehicleController>().vehicleId.value!;

    await writePreference(vehicleId, prefName, value);
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

  @override
  void onClose() {
    // Close subscriptions.
    for (var element in subscriptions) {
      element.cancel();
    }

    super.onClose();
  }
}
