import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:deart/utils/unit_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TPMSController extends GetxController {
  RxDouble frontLeft = 0.0.obs;
  RxDouble frontRight = 0.0.obs;
  RxDouble rearLeft = 0.0.obs;
  RxDouble rearRight = 0.0.obs;

  @override
  void onReady() async {
    String? frontLeftText = await readVehicleStorageKey(
        Get.find<VehicleController>().vehicleId.value!, 'tp_fl');

    if (frontLeftText != null) {
      frontLeft.value = barToPSI(double.parse(frontLeftText));
    }

    String? frontRightText = await readVehicleStorageKey(
        Get.find<VehicleController>().vehicleId.value!, 'tp_fr');

    if (frontRightText != null) {
      frontRight.value = barToPSI(double.parse(frontRightText));
    }

    String? rearLeftText = await readVehicleStorageKey(
        Get.find<VehicleController>().vehicleId.value!, 'tp_rl');

    if (rearLeftText != null) {
      rearLeft.value = barToPSI(double.parse(rearLeftText));
    }

    String? rearRightText = await readVehicleStorageKey(
        Get.find<VehicleController>().vehicleId.value!, 'tp_rr');

    if (rearRightText != null) {
      rearRight.value = barToPSI(double.parse(rearRightText));
    }
    super.onReady();
  }

  bool isLowPressure(double value) {
    return value > 0 && value < 38;
  }

  Color getTextColor(double value) {
    if (isLowPressure(value)) {
      return Colors.orange;
    } else {
      return Colors.white;
    }
  }

  void close() {
    Get.back();
  }
}
