import 'package:deart/controllers/home_controller.dart';
import 'package:deart/models/internal/work_flow_preset.dart';
import 'package:deart/utils/ui_utils.dart';
import 'package:deart/widgets/car_image.dart';
import 'package:deart/widgets/theme/deart_elevated_icon.dart';
import 'package:flutter/material.dart';
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Card(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: ElevatedButton.icon(
                        //       onPressed: () => controller.carLocked.value
                        //           ? controller.unlock()
                        //           : controller.lock(),
                        //       label: Text(
                        //         controller.carLocked.value ? 'Unlock' : 'Lock',
                        //       ),
                        //       icon: Icon(
                        //         controller.carLocked.value
                        //             ? Icons.lock_open
                        //             : Icons.lock,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: Text('Automations:'),
                                ),
                                DearTElevatedButtton(
                                  onPressed: () async => await controller
                                      .startWorkFlow(WorkFlowPreset.findMyCar),
                                  label: 'Find My Car',
                                  icon: Icons.radar,
                                ),
                                DearTElevatedButtton(
                                  label: 'Flash Lights',
                                  icon: Icons.flourescent_outlined,
                                  onPressed: controller.flashLights,
                                ),
                                // ElevatedButton.icon(
                                //   onPressed: () => controller.flashLights(),
                                //   label: const Text('Flash Lights'),
                                //   icon: const Icon(
                                //     Icons.flourescent_outlined,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Visibility(
                                  visible: !controller.isChargerPluggedIn.value,
                                  child: const Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Text('Not plugged in'),
                                  ),
                                ),
                                Visibility(
                                  visible: controller.isChargerPluggedIn.value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                        'Plugged in (${controller.chargingCurrent}A/${controller.chargingCurrentMax}A)'),
                                  ),
                                ),
                                Visibility(
                                  visible: controller.isCharging.value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      'Finishing at ${controller.getFinishTime(controller.timeToFullCharge.value)}',
                                    ),
                                  ),
                                ),
                                DearTElevatedButtton(
                                  onPressed: !controller.isChargePortOpen.value
                                      ? controller.openChargePort
                                      : controller.closeChargePort,
                                  label: controller.isChargePortOpen.value
                                      ? 'Close Port'
                                      : 'Open Port',
                                  icon: Icons.ev_station_outlined,
                                ),
                                Visibility(
                                  visible: controller.isChargerPluggedIn.value,
                                  child: DearTElevatedButtton(
                                    onPressed: !controller.isCharging.value
                                        ? controller.startCharging
                                        : controller.stopCharging,
                                    label: controller.isCharging.value
                                        ? 'Stop'
                                        : 'Start',
                                    icon: controller.isCharging.value
                                        ? Icons.stop
                                        : Icons.play_arrow,
                                  ),
                                ),
                                Visibility(
                                  visible: controller.isCharging.value,
                                  child: DearTElevatedButtton(
                                      onPressed: controller.stopChargeAndUnlock,
                                      label: 'Stop + Unlock',
                                      icon: Icons.lock_open),
                                ),
                                Visibility(
                                  visible: !controller.isCharging.value &&
                                      controller.isChargerLocked.value,
                                  child: DearTElevatedButtton(
                                    onPressed: controller.unlockCharger,
                                    icon: Icons.exit_to_app,
                                    label: 'Unlock',
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Stack(
                            children: [
                              const CarImageWidget(),
                              Visibility(
                                visible: !controller.isFrunkOpen.value,
                                child: Positioned.fill(
                                  top: 25,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: ElevatedButton(
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
                              Visibility(
                                visible: !controller.isFrunkOpen.value,
                                child: Positioned.fill(
                                  bottom: 10,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ElevatedButton(
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Sentry Mode State: ${controller.sentryModeStateText}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
