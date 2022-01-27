import 'package:deart/controllers/home_controller.dart';
import 'package:deart/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class VehiclePage extends GetView<HomeController> {
  const VehiclePage({Key? key}) : super(key: key);

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
                        onPressed: () => controller.carLocked.value
                            ? controller.unlock()
                            : controller.lock(),
                        label: Text(
                          controller.carLocked.value ? 'Unlock' : 'Lock',
                        ),
                        icon: Icon(
                          controller.carLocked.value
                              ? Icons.lock_open
                              : Icons.lock,
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
                        Positioned(
                          right: 73,
                          bottom: 60,
                          child: OutlinedButton(
                            onPressed: () => openSnackbar(
                              'Trunk',
                              'Long press to open',
                              currentSnackbar: controller.snackBar,
                            ),
                            onLongPress: () => controller.openTrunk(),
                            child: Text(
                              controller.isTrunkOpen.value ? 'Close' : 'Open',
                            ),
                          ),
                        ),
                        Positioned(
                          right: 73,
                          top: 40,
                          child: Visibility(
                            visible: !controller.isFrunkOpen.value,
                            child: OutlinedButton(
                              onPressed: () => openSnackbar(
                                'Frunk',
                                'Long press to open',
                                currentSnackbar: controller.snackBar,
                              ),
                              onLongPress: () => controller.openFrunk(),
                              child: const Text(
                                'Open',
                              ),
                            ),
                          ),
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Car is ${controller.carLocked.value ? 'locked' : 'unlocked'}.',
                      ),
                    ),
                    Text(
                      'Sentry Mode State: ${controller.sentryModeStateText}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
