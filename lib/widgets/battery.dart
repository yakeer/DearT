import 'dart:math';

import 'package:deart/controllers/home_controller.dart';
import 'package:deart/controllers/user_controller.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:flutter/cupertino.dart';
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
                  _getIcon(),
                  Text(
                    getBatteryText(controller.showBatteryLevel.value),
                    style: TextStyle(color: getColor()),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !controller.isInitialDataLoaded.value,
              child: SizedBox(
                height: 20,
                width: 20,
                child: Container(),
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

  String getBatteryText(bool showBatteryLevel) {
    if (showBatteryLevel) {
      return '${controller.batteryLevel}%';
    } else {
      return '${controller.batteryRange.truncate()}km';
    }
  }

  Color getColor() {
    if (controller.batteryLevel > 20) {
      return Colors.white;
    } else if (controller.batteryLevel <= 20 && controller.batteryLevel > 10) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget _getIcon() {
    if (controller.isCharging.value) {
      return Icon(
        Icons.battery_charging_full,
        color: getColor(),
      );
    }

    if (controller.batteryLevel > 0) {
      if (controller.batteryLevel > 0 && controller.batteryLevel <= 20) {
        return Transform.rotate(
          angle: -90 * pi / 180,
          child: Icon(
            CupertinoIcons.battery_empty,
            color: getColor(),
          ),
        );
      } else if (controller.batteryLevel > 20 &&
          controller.batteryLevel <= 50) {
        return Transform.rotate(
          angle: -90 * pi / 180,
          child: Icon(
            CupertinoIcons.battery_25_percent,
            color: getColor(),
          ),
        );
      } else if (controller.batteryLevel > 50 &&
          controller.batteryLevel <= 75) {
        return Transform.rotate(
          angle: -90 * pi / 180,
          child: Icon(
            CupertinoIcons.battery_75_percent,
            color: getColor(),
          ),
        );
      } else {
        return Transform.rotate(
          angle: -90 * pi / 180,
          child: Icon(
            CupertinoIcons.battery_empty,
            color: getColor(),
          ),
        );
      }
    } else {
      return Icon(
        Icons.battery_unknown_outlined,
        color: getColor(),
      );
    }
  }
}
