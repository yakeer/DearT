import 'package:deart/controllers/home_controller.dart';
import 'package:deart/widgets/theme/deart_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickActionsWidget extends GetView<HomeController> {
  const QuickActionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DearTIconButtton(
            onTap: controller.turnOnSentry,
            icon: Icons.add_moderator_outlined,
            label: 'Arm',
          ),
          DearTIconButtton(
            onTap: controller.turnOffSentry,
            icon: Icons.remove_moderator_outlined,
            label: 'Disarm',
          ),
          DearTIconButtton(
            onTap: controller.horn,
            icon: Icons.volume_down_outlined,
            label: 'Horn',
          ),
          // DearTIconButtton(
          //   onTap: controller.flashLights,
          //   icon: Icons.flourescent_outlined,
          //   label: 'Flash',
          // ),
          DearTIconButtton(
            onTap: controller.carLocked.value
                ? controller.unlock
                : controller.lock,
            icon: controller.carLocked.value ? Icons.lock_open : Icons.lock,
            label: controller.carLocked.value ? 'Unlock' : 'Lock',
          ),
        ],
      ),
    );
  }
}