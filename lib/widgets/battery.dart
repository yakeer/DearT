import 'package:deart/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatteryWidget extends GetView<HomeController> {
  const BatteryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => GestureDetector(
        onTap: () => switchMode(),
        child: Row(
          children: [
            Icon(_getIcon()),
            Text(
              '${controller.batteryRange.round()}km (${controller.batteryLevel}%)',
            ),
          ],
        ),
      ),
    );
  }

  void switchMode() {}

  IconData _getIcon() {
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
