import 'package:deart/controllers/home_controller.dart';
import 'package:deart/models/internal/work_flow_preset.dart';
import 'package:deart/utils/ui_utils.dart';
import 'package:deart/widgets/car_image.dart';
import 'package:deart/widgets/charge_widget.dart';
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
                        Card(
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
                                DearTElevatedButtton(
                                  onPressed: () async => await controller
                                      .startWorkFlow(WorkFlowPreset.findMyCar),
                                  label: 'Find My Car',
                                  icon: Icons.radar,
                                  longPressPopupTitle: "Find My Car",
                                  longPressPopupMessage:
                                      controller.getWorkFlowPopupMessage(
                                          WorkFlowPreset.findMyCar),
                                ),
                                DearTElevatedButtton(
                                  label: 'Flash Lights',
                                  icon: Icons.flourescent_outlined,
                                  onPressed: controller.flashLights,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                        const ChargeWidget(),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
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
