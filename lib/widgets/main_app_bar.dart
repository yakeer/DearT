import 'package:deart/controllers/home_controller.dart';
import 'package:deart/controllers/user_controller.dart';
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
                      iconSize:
                          controller.vehicles.value?.length == 1 ? 0.0 : 24,
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
                      onChanged: (int? newVehicleId) =>
                          Get.find<UserController>().carChanged(
                        newVehicleId,
                        reloadData: true,
                      ),
                    ),
                  ),
            const BatteryWidget(),
            IconButton(
                onPressed: controller.goToSettings,
                icon: const Icon(Icons.settings))
          ],
        ),
      ),
    );
  }
}
