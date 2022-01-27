import 'package:deart/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ChargePage extends GetView<HomeController> {
  const ChargePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => !controller.isChargePortOpen.value
                            ? controller.openChargePort()
                            : controller.closeChargePort(),
                        label: Text(
                          controller.isChargePortOpen.value
                              ? 'Close Port'
                              : 'Open Port',
                        ),
                        icon: const Icon(
                          Icons.battery_charging_full_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        SvgPicture.asset(
                          'assets/images/upper_view.svg',
                          semanticsLabel: 'Upper view',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Charge Mode State: ${controller.sentryModeStateText}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
