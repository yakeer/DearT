import 'package:deart/constants.dart';
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
            SizedBox(
              height: Constants.pageControllerHeight - 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Visibility(
                            visible: !controller.isChargerPluggedIn.value,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  !controller.isChargePortOpen.value
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
                          ),
                          Visibility(
                            visible: controller.isChargerPluggedIn.value,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                          'Plugged in (${controller.chargingCurrent}A/${controller.chargingCurrentMax}A)'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          !controller.isCharging.value
                                              ? controller.startCharging()
                                              : controller.stopCharging(),
                                      child: Text(
                                        controller.isCharging.value
                                            ? 'Stop'
                                            : 'Start',
                                      ),
                                    ),
                                    Visibility(
                                      visible: controller.isCharging.value,
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            controller.stopChargeAndUnlock(),
                                        child: const Text('Stop + Unlock'),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !controller.isCharging.value &&
                                          controller.isChargerLocked.value,
                                      child: ElevatedButton.icon(
                                        onPressed: () =>
                                            controller.unlockCharger(),
                                        icon: const Icon(Icons.exit_to_app),
                                        label: const Text('Unlock'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                          Positioned.fill(
                            bottom: 60,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: TextButton(
                                onPressed: () => openSnackbar(
                                  'Trunk',
                                  'Long press to open',
                                  currentSnackbar: controller.snackBar,
                                ),
                                onLongPress: () => controller.openTrunk(),
                                child: Text(
                                  controller.isTrunkOpen.value
                                      ? 'Close'
                                      : 'Open',
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            top: Get.mediaQuery.size.height - 800,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Visibility(
                                visible: !controller.isFrunkOpen.value,
                                child: TextButton(
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
