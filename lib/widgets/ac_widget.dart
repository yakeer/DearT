import 'package:deart/controllers/home_controller.dart';
import 'package:deart/widgets/theme/deart_elevated_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

class ACWidget extends GetView<HomeController> {
  const ACWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'A/C Control:',
                style: Get.theme.textTheme.caption,
              ),
              NumberPicker(
                textStyle: Get.textTheme.caption,
                textMapper: (numberText) => '${double.parse(numberText) / 2.0}',
                haptics: true,
                value: controller.acTemperatureSetInt.value,
                minValue:
                    (controller.acMinTemperatureAvailable.value * 2).toInt(),
                maxValue:
                    (controller.acMaxTemperatureAvailable.value * 2).toInt(),
                onChanged: (value) {
                  controller.acTemperatureSetInt.value = value;
                  controller.acTemperatureSet.value = value / 2.0;
                },
                itemCount: 7,
                itemHeight: 32,
                itemWidth: 50,
                axis: Axis.horizontal,
              ),
              DearTElevatedButtton(
                disabled: controller.acTemperatureCurrent.value ==
                    controller.acTemperatureSet.value,
                onPressed: controller.setACTemperature,
                label: 'Set',
                icon: Icons.tune,
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Visibility(
                    visible: !controller.isClimateOn.value,
                    child: Expanded(
                      child: DearTElevatedButtton(
                        onPressed: controller.acStart,
                        label: 'Turn On',
                        icon: Icons.ac_unit,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.isClimateOn.value,
                    child: Expanded(
                      child: DearTElevatedButtton(
                        onPressed: controller.acStop,
                        label: 'Turn Off',
                        icon: Icons.ac_unit,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Visibility(
                    visible: !controller.anyWindowOpen(),
                    child: Expanded(
                      child: DearTElevatedButtton(
                        onPressed: controller.ventWindows,
                        label: 'Vent Windows',
                        icon: Icons.sensor_window_outlined,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.anyWindowOpen(),
                    child: Expanded(
                      child: DearTElevatedButtton(
                        onPressed: controller.closeWindows,
                        label: 'Close Windows',
                        icon: Icons.sensor_window,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
