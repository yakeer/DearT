import 'package:deart/controllers/tpms_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TPMSWidget extends GetView<TPMSController> {
  const TPMSWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<TPMSController>(
      init: TPMSController(),
      builder: (controller) => Stack(
        alignment: Alignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Image(
              image: AssetImage(
                'assets/images/controls/base.png',
              ),
            ),
          ),
          Positioned.fill(
            top: 70,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                controller.frontLeft.value.toStringAsFixed(1),
                style: TextStyle(
                  color: controller.getTextColor(controller.frontLeft.value),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 70,
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                controller.frontRight.value.toStringAsFixed(1),
                style: TextStyle(
                  color: controller.getTextColor(controller.frontRight.value),
                ),
              ),
            ),
          ),
          Positioned.fill(
            bottom: 70,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                controller.rearLeft.value.toStringAsFixed(1),
                style: TextStyle(
                  color: controller.getTextColor(controller.rearLeft.value),
                ),
              ),
            ),
          ),
          Positioned.fill(
            bottom: 70,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                controller.rearRight.value.toStringAsFixed(1),
                style: TextStyle(
                  color: controller.getTextColor(controller.rearRight.value),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
