import 'package:deart/controllers/home_controller.dart';
import 'package:deart/controllers/user_controller.dart';
import 'package:deart/utils/ui_utils.dart';
import 'package:deart/widgets/battery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainAppBar extends GetView<HomeController>
    implements PreferredSizeWidget {
  const MainAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => AppBar(
        leading: Visibility(
          visible: controller.isInitialDataLoaded.value &&
              (!controller.carLocked.value ||
                  controller.anyDoorOpen() ||
                  controller.anyWindowOpen()),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: !controller.carLocked.value,
                child: GestureDetector(
                  onTap: () => openPopup('Warning', 'Car is unlocked.'),
                  child: const Icon(
                    Icons.lock_open,
                    color: Colors.orange,
                  ),
                ),
              ),
              Visibility(
                visible:
                    controller.carLocked.value && controller.anyWindowOpen(),
                child: GestureDetector(
                  onTap: () =>
                      openPopup('Warning', 'Some of the windows are open.'),
                  child: const Icon(
                    Icons.sensor_window,
                    color: Colors.orange,
                  ),
                ),
              ),
              Visibility(
                visible: controller.carLocked.value && controller.anyDoorOpen(),
                child: GestureDetector(
                  onTap: () =>
                      openPopup('Warning', 'Some of the doors are open.'),
                  child: const Icon(
                    Icons.door_back_door,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
        leadingWidth: controller.isInitialDataLoaded.value &&
                (!controller.carLocked.value ||
                    controller.anyDoorOpen() ||
                    controller.anyWindowOpen())
            ? 30
            : 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            controller.vehicles.value?.length == 1
                ? Text(
                    "${controller.vehicleName}",
                  )
                : DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      style: Get.theme.textTheme.headline6,
                      iconSize: 24,
                      value: controller.vehicleId.value,
                      items: controller.vehicles.value
                          ?.map(
                            (veh) => DropdownMenuItem<int>(
                              child: Text(
                                veh.displayName,
                              ),
                              value: veh.id,
                            ),
                          )
                          .toList(),
                      onChanged: (int? newVehicleId) {
                        if (newVehicleId != null) {
                          Get.find<UserController>().carChanged(
                            newVehicleId,
                            controller.vehicles.value!
                                .firstWhere(
                                    (element) => element.id == newVehicleId)
                                .displayName,
                            reloadData: true,
                          );
                        }
                      },
                    ),
                  ),
            const BatteryWidget(),
            Visibility(
              visible: controller.isInitialDataLoaded.value,
              child: Row(
                children: [
                  Text(
                    "${controller.insideTemperature.toInt()}\u00B0/${controller.outsideTemperature.toInt()}\u00B0",
                  )
                ],
              ),
            )
            // IconButton(
            //     onPressed: controller.goToSettings,
            //     icon: const Icon(Icons.settings))
          ],
        ),
      ),
    );
  }
}
