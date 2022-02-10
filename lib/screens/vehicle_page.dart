import 'package:deart/controllers/home_controller.dart';
import 'package:deart/controllers/user_controller.dart';
import 'package:deart/models/internal/work_flow_preset.dart';
import 'package:deart/widgets/charge_widget.dart';
import 'package:deart/widgets/controls_widget.dart';
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
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const ChargeWidget(),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      children: const [
                        ControlsWidget(),
                      ],
                    ),
                  ),
                ],
              ),
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
                      SizedBox(
                        height: 60,
                        child: DearTElevatedButtton(
                          onPressed: () async => await controller
                              .startWorkFlow(WorkFlowPreset.findMyCar),
                          label: 'Locate',
                          icon: Icons.radar,
                          longPressPopupTitle: "Locate",
                          longPressPopupMessage:
                              controller.getWorkFlowPopupMessage(
                                  WorkFlowPreset.findMyCar),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: Get.find<UserController>()
                      .getPreference<bool>('sentryQuickActionToggle')! ==
                  false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Sentry Mode State: ${controller.sentryModeStateText}',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
