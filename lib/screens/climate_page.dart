import 'package:deart/controllers/home_controller.dart';
import 'package:deart/models/internal/work_flow_preset.dart';
import 'package:deart/widgets/ac_widget.dart';
import 'package:deart/widgets/heaters_widget.dart';
import 'package:deart/widgets/theme/deart_elevated_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClimatePage extends GetView<HomeController> {
  const ClimatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flex(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Icon(Icons.thermostat),
                          Text('Inside: ${controller.insideTemperature}\u2103'),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Icon(Icons.thermostat),
                          Text(
                              'Outside: ${controller.outsideTemperature}\u2103'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const ACWidget(),
            const HeatersWidget(),
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
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      'Automations:',
                                      style: Get.theme.textTheme.caption,
                                    ),
                                  ),
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 60,
                                          child: DearTElevatedButtton(
                                            onPressed: () async =>
                                                await controller.startWorkFlow(
                                                    WorkFlowPreset.preheat),
                                            label: 'Preheat Cabin',
                                            icon: Icons.hot_tub,
                                            longPressPopupMessage: controller
                                                .getWorkFlowPopupMessage(
                                              WorkFlowPreset.preheat,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 60,
                                          child: DearTElevatedButtton(
                                            onPressed: () async =>
                                                await controller.startWorkFlow(
                                                    WorkFlowPreset.precool),
                                            label: 'Precool Cabin',
                                            icon: Icons.ac_unit,
                                            longPressPopupMessage: controller
                                                .getWorkFlowPopupMessage(
                                              WorkFlowPreset.precool,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
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
