import 'package:deart/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

import 'package:get/get.dart';

class DiagnosticsScreen extends GetView<SettingsController> {
  const DiagnosticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diangnostics'),
      ),
      body: SettingsList(
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
                title: 'Streaming Log',
                subtitle: 'Experimental',
                onPressed: (context) => Get.toNamed('/stream'),
              ),
              SettingsTile(
                title: 'Vehicle Data',
                trailing: const Text('Copy'),
                onPressed: (context) => controller.copyVehicleData(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
