import 'package:deart/controllers/home_controller.dart';
import 'package:deart/widgets/ac_widget.dart';
import 'package:deart/widgets/heaters_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClimatePage extends GetView<HomeController> {
  const ClimatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
