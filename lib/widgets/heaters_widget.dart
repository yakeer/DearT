import 'package:deart/controllers/home_controller.dart';
import 'package:deart/widgets/theme/deart_toggle_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeatersWidget extends GetView<HomeController> {
  const HeatersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Heaters:',
                style: Get.theme.textTheme.caption,
              ),
              Center(
                child: SizedBox(
                  width: Get.mediaQuery.size.width / 2,
                  child: DearTHeaterButton(
                    heaterValue: controller.isStreeringWheelHeaterOn.value,
                    icon: const Icon(CupertinoIcons.circle),
                    onPressed: controller.toggleSteeringWheelHeater,
                    isBinary: true,
                  ),
                ),
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: DearTHeaterButton(
                      heaterValue: controller.seatHeaterLeft.value,
                      icon: const Icon(CupertinoIcons.arrow_left),
                      onPressed: () => controller.toggleSeatHeader(
                          0, controller.seatHeaterLeft),
                      isBinary: false,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DearTHeaterButton(
                      heaterValue: controller.seatHeaterRight.value,
                      icon: const Icon(CupertinoIcons.arrow_right),
                      onPressed: () => controller.toggleSeatHeader(
                          1, controller.seatHeaterRight),
                      isBinary: false,
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: controller.hasRearSeatHeaters.value,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: DearTHeaterButton(
                        heaterValue: controller.seatHeaterRearLeft.value,
                        icon: const Icon(CupertinoIcons.arrow_left_circle_fill),
                        onPressed: () => controller.toggleSeatHeader(
                            2, controller.seatHeaterRearLeft),
                        isBinary: false,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: DearTHeaterButton(
                        heaterValue: controller.seatHeaterRearCenter.value,
                        icon: const Icon(CupertinoIcons.arrow_down_circle_fill),
                        onPressed: () => controller.toggleSeatHeader(
                            4, controller.seatHeaterRearCenter),
                        isBinary: false,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: DearTHeaterButton(
                        heaterValue: controller.seatHeaterRearRight.value,
                        icon:
                            const Icon(CupertinoIcons.arrow_right_circle_fill),
                        onPressed: () => controller.toggleSeatHeader(
                            5, controller.seatHeaterRearRight),
                        isBinary: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
