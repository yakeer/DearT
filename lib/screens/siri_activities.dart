import 'package:deart/controllers/settings_controller.dart';
import 'package:deart/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SiriActivitiesScreen extends GetView<SettingsController> {
  const SiriActivitiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Siri Shortcuts'),
      ),
      body: ListView.builder(
        itemCount: controller.siriActivities.value!.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(
            controller.siriActivities.value![index].title,
          ),
          trailing: const Text('Install'),
          onTap: () {
            controller.installSiriShortcut(
              controller.siriActivities.value![index],
            );

            openSnackbar(
              'Siri Shortcut',
              '${controller.siriActivities.value![index].title} shortcut installed successfully.',
            );
          },
        ),
      ),
    );
  }
}
