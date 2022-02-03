import 'package:deart/controllers/home_controller.dart';
import 'package:deart/controllers/user_controller.dart';
import 'package:deart/models/internal/vehicle_preference.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatteryWidget extends GetView<HomeController> {
  const BatteryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => GestureDetector(
        onTap: () => switchMode(),
        child: Column(
          children: [
            Visibility(
              visible: controller.isInitialDataLoaded.value,
              child: Row(
                children: [
                  Icon(_getIcon()),
                  Text(
                    getBatteryText(),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !controller.isInitialDataLoaded.value,
              child: const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void switchMode() {
    // Toggle
    controller.showBatteryLevel.value = !controller.showBatteryLevel.value;

    // Save Preference.
    Get.find<UserController>().setPreference(
      'showBatteryLevelInAppBar',
      controller.showBatteryLevel.value,
    );

    writePreference(controller.vehicleId.value!, 'showBatteryLevelInAppBar',
        controller.showBatteryLevel.value);
  }

  String getBatteryText() {
    if (controller.showBatteryLevel.value) {
      return '${controller.batteryLevel}%';
    } else {
      return '${controller.batteryRange.round()}km';
    }
  }

  IconData _getIcon() {
    if (controller.isCharging.value) {
      return Icons.battery_charging_full;
    }

    if (controller.batteryLevel > 0) {
      if (controller.batteryLevel > 0 && controller.batteryLevel <= 20) {
        return Icons.battery_alert_outlined;
      } else {
        return Icons.battery_std_outlined;
      }
    } else {
      return Icons.battery_unknown_outlined;
    }
  }
}
