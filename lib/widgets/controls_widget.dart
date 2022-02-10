import 'package:deart/controllers/home_controller.dart';
import 'package:deart/utils/ui_utils.dart';
import 'package:deart/widgets/theme/deart_elevated_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControlsWidget extends GetView<HomeController> {
  const ControlsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Controls:',
                  style: Get.theme.textTheme.caption,
                ),
              ),
              Visibility(
                visible: !controller.isFrunkOpen.value,
                child: ElevatedButton(
                  onPressed: () => openSnackbar(
                    'Frunk',
                    'Long press to open',
                    currentSnackbar: controller.snackBar,
                  ),
                  onLongPress: () => controller.openFrunk(),
                  child: const Text(
                    'Open Frunk',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => openSnackbar(
                  'Trunk',
                  'Long press to open',
                  currentSnackbar: controller.snackBar,
                ),
                onLongPress: () => controller.openTrunk(),
                child: Text(
                  controller.isTrunkOpen.value ? 'Close Trunk' : 'Open Trunk',
                ),
              ),
              Visibility(
                visible: !controller.isPreconditioning.value,
                child: DearTElevatedButtton(
                  onPressed: controller.turnOnMaxDefrost,
                  label: 'Defrost Car',
                  // icon: CupertinoIcons.brightness_solid,
                  icon: Icons.ac_unit,
                ),
              ),
              Visibility(
                visible: controller.isPreconditioning.value,
                child: DearTElevatedButtton(
                  onPressed: controller.turnOffMaxDefrost,
                  label: 'Stop Defrost',
                  // icon: CupertinoIcons.brightness,
                  icon: Icons.ac_unit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
