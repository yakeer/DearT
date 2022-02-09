import 'package:deart/controllers/home_controller.dart';
import 'package:deart/widgets/theme/deart_elevated_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChargeWidget extends GetView<HomeController> {
  const ChargeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Visibility(
                visible: !controller.isChargerPluggedIn.value,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Charger Unplugged',
                    style: Get.theme.textTheme.caption,
                  ),
                ),
              ),
              Visibility(
                visible: controller.isChargerPluggedIn.value,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Plugged in (${controller.chargingCurrent}A/${controller.chargingCurrentMax}A)',
                    style: Get.theme.textTheme.caption,
                  ),
                ),
              ),
              Visibility(
                visible: controller.isCharging.value,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Finishing at ${controller.getFinishTime(controller.timeToFullCharge.value)}',
                    style: Get.theme.textTheme.caption,
                  ),
                ),
              ),
              Visibility(
                visible: !controller.isChargePortOpen.value,
                child: DearTElevatedButtton(
                  onPressed: controller.openChargePort,
                  label: 'Open Port',
                  icon: Icons.ev_station_outlined,
                ),
              ),
              Visibility(
                visible: controller.isChargePortOpen.value &&
                    !controller.isChargerPluggedIn.value,
                child: DearTElevatedButtton(
                  onPressed: controller.closeChargePort,
                  label: 'Close Port',
                  icon: Icons.ev_station,
                ),
              ),
              Visibility(
                visible: controller.isChargerPluggedIn.value &&
                    !controller.isCharging.value &&
                    controller.canChargeMore.value,
                child: DearTElevatedButtton(
                  onPressed: controller.startCharging,
                  label: 'Start',
                  icon: Icons.play_arrow,
                ),
              ),
              Visibility(
                visible: controller.isChargerPluggedIn.value &&
                    controller.isCharging.value,
                child: DearTElevatedButtton(
                  onPressed: controller.stopCharging,
                  label: 'Stop',
                  icon: Icons.stop,
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
                    controller.isChargerPluggedIn.value &&
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
    );
  }
}
