import 'package:deart/controllers/home_controller.dart';
import 'package:deart/models/internal/work_flow_preset.dart';
import 'package:deart/widgets/car_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

class ClimatePage extends GetView<HomeController> {
  const ClimatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'A/C Temp:',
                                  style: Get.theme.textTheme.caption,
                                ),
                                NumberPicker(
                                  textStyle: Get.textTheme.caption,
                                  textMapper: (numberText) =>
                                      '${double.parse(numberText) / 2.0}',
                                  haptics: true,
                                  value: controller.acTemperatureSetInt.value,
                                  minValue: (controller
                                              .acMinTemperatureAvailable.value *
                                          2)
                                      .toInt(),
                                  maxValue: (controller
                                              .acMaxTemperatureAvailable.value *
                                          2)
                                      .toInt(),
                                  onChanged: (value) {
                                    controller.acTemperatureSetInt.value =
                                        value;
                                    controller.acTemperatureSet.value =
                                        value / 2.0;
                                  },
                                  itemCount: 3,
                                  itemHeight: 32,
                                  itemWidth: 50,
                                  axis: Axis.horizontal,
                                ),
                                ElevatedButton(
                                  onPressed:
                                      controller.acTemperatureCurrent.value !=
                                              controller.acTemperatureSet.value
                                          ? () => controller.setACTemperature()
                                          : null,
                                  child: const Text('Set'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'A/C Control:',
                                  style: Get.theme.textTheme.caption,
                                ),
                                Visibility(
                                  visible: !controller.isClimateOn.value,
                                  child: ElevatedButton(
                                    onPressed: () => controller.acStart(),
                                    child: const Text('Turn On'),
                                  ),
                                ),
                                Visibility(
                                  visible: controller.isClimateOn.value,
                                  child: ElevatedButton(
                                    onPressed: () => controller.acStop(),
                                    child: const Text('Turn Off'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Automations:',
                                    style: Get.theme.textTheme.caption,
                                  ),
                                  ElevatedButton(
                                    onPressed: () => controller
                                        .startWorkFlow(WorkFlowPreset.preheat),
                                    child: const Text('Preheat Cabin'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => controller
                                        .startWorkFlow(WorkFlowPreset.precool),
                                    child: const Text('Precool Cabin'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Color.fromRGBO(Colors.black.red,
                                Colors.black.green, Colors.black.blue, 0.5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.thermostat),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Outside'),
                                      Text(
                                          '${controller.outsideTemperature}\u2103'),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32.0),
                          child: Stack(
                            children: [
                              const Center(
                                child: CarImageWidget(),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Card(
                                    color: Color.fromRGBO(
                                      Colors.black.red,
                                      Colors.black.green,
                                      Colors.black.blue,
                                      0.5,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.thermostat),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text('Inside'),
                                              Text(
                                                  '${controller.insideTemperature}\u2103'),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
