import 'package:deart/controllers/home_controller.dart';
import 'package:deart/utils/unit_utils.dart';
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
              '${mileToKM(controller.chargeState.value?.batteryRange) ?? 'N/A'}km (${controller.chargeState.value?.batteryLevel ?? 'N/A'}%)',
            ),
          ],
        ),
      ),
    );
  }

  void switchMode() {}

  IconData _getIcon() {
    if (controller.chargeState.value != null) {
      if (controller.chargeState.value!.batteryLevel > 0 &&
          controller.chargeState.value!.batteryLevel <= 20) {
        return Icons.battery_alert_outlined;
      } else {
        return Icons.battery_std_outlined;
      }
    } else {
      return Icons.battery_unknown_outlined;
    }
  }
}
