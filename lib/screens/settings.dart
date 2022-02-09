import 'package:deart/controllers/home_controller.dart';
import 'package:deart/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:get/get.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SettingsController>(
      init: SettingsController(),
      builder: (controller) => SettingsList(
        // darkBackgroundColor: Get.theme.colorScheme.background,
        // darkBackgroundColor: Colors.transparent,
        backgroundColor: Colors.black,
        contentPadding: const EdgeInsets.all(8),
        sections: [
          SettingsSection(
            title: 'General',
            titleTextStyle: Get.theme.textTheme.headline6,
            tiles: [
              SettingsTile(
                title: 'App Version ',
                trailing: Text('${controller.appVersion}'),
              ),
              SettingsTile(
                title: 'Car Version ',
                trailing: Text('${controller.carVersion}'),
              ),
              SettingsTile.switchTile(
                title: 'Prefer Battery %',
                switchValue: controller.showBatteryLevelInAppBar.value,
                onToggle: (bool value) {
                  controller.changeToggle('showBatteryLevelInAppBar',
                      controller.showBatteryLevelInAppBar, value,
                      refVariableInHomeScreen:
                          Get.find<HomeController>().showBatteryLevel);
                },
              )
            ],
          ),
          SettingsSection(
            title: 'In-App Purchases',
            titleTextStyle: Get.theme.textTheme.headline6,
            tiles: [
              SettingsTile(
                title: 'Buy Premium Features',
                onPressed: (context) => controller.goToPurchases(),
              ),
            ],
          ),
          SettingsSection(
            title: 'Automations',
            titleTextStyle: Get.theme.textTheme.headline6,
            tiles: [
              SettingsTile.switchTile(
                title: 'Activate Sentry when charging',
                switchValue: controller.activateSentryWhenCharging.value,
                onToggle: (bool value) {
                  controller.changeToggle(
                    'activateSentry',
                    controller.activateSentryWhenCharging,
                    value,
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            platform: TargetPlatform.iOS,
            title: 'iOS',
            titleTextStyle: Get.theme.textTheme.headline6,
            tiles: [
              SettingsTile(
                platform: TargetPlatform.iOS,
                title: 'Install Siri Shortcuts',
                onPressed: (context) async {
                  Get.toNamed('/siri-shortcuts');
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Account',
            titleTextStyle: Get.theme.textTheme.headline6,
            tiles: [
              SettingsTile(
                title: 'Access Token',
                trailing: const Text('Copy'),
                onPressed: (context) => controller.copyAccessToken(),
              ),
              SettingsTile(
                title: 'Refresh Token',
                trailing: const Text('Copy'),
                onPressed: (context) => controller.copyRefreshToken(),
              ),
              SettingsTile(
                title: 'Streaming Log',
                onPressed: (context) => Get.toNamed('/stream'),
              ),
              SettingsTile(
                title: 'Logout Tesla Account',
                onPressed: (context) => controller.logoutTeslaAccount(),
              ),
              SettingsTile(
                title: 'Logout DearT',
                onPressed: (context) => controller.logout(),
              )
            ],
          )
        ],
      ),
    );
  }
}
