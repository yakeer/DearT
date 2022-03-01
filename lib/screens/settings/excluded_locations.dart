import 'package:deart/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:get/get.dart';

class ExcludedLocationsScreen extends GetView<SettingsController> {
  const ExcludedLocationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SettingsController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Excluded Locations',
          ),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: 'Sentry Mode',
              tiles: [
                ...controller.excludedLocationTiles.value,
                SettingsTile(
                  title: 'Add Current Car Location...',
                  onPressed: (context) =>
                      controller.addCurrentVehicleLocation(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
