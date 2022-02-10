import 'package:deart/controllers/home_controller.dart';
import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeatersWidget extends GetView<HomeController> {
  const HeatersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Heaters:',
                style: Get.theme.textTheme.caption,
              ),
              GestureDetector(
                onVerticalDragEnd: (details) => turnAllOff(),
                onTapUp: (details) => handleTap(details),
                onLongPressEnd: (details) => handleLongPress(details),
                child: Stack(
                  children: [
                    const Image(
                      image: AssetImage(
                        'assets/images/heaters/base.png',
                      ),
                    ),
                    ..._getLayers()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // return GetX<HomeController>(
    //   builder: (controller) => Card(
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             'Heaters:',
    //             style: Get.theme.textTheme.caption,
    //           ),
    //           Center(
    //             child: SizedBox(
    //               width: Get.mediaQuery.size.width / 2,
    //               child: DearTHeaterButton(
    //                 heaterValue: controller.isStreeringWheelHeaterOn.value,
    //                 icon: const Icon(CupertinoIcons.circle),
    //                 onPressed: controller.toggleSteeringWheelHeater,
    //                 isBinary: true,
    //               ),
    //             ),
    //           ),
    //           Flex(
    //             direction: Axis.horizontal,
    //             children: [
    //               Expanded(
    //                 child: DearTHeaterButton(
    //                   heaterValue: controller.seatHeaterLeft.value,
    //                   icon: const Icon(CupertinoIcons.arrow_left),
    //                   onPressed: () => controller.toggleSeatHeader(
    //                       0, controller.seatHeaterLeft),
    //                   isBinary: false,
    //                 ),
    //               ),
    //               const SizedBox(
    //                 width: 8,
    //               ),
    //               Expanded(
    //                 child: DearTHeaterButton(
    //                   heaterValue: controller.seatHeaterRight.value,
    //                   icon: const Icon(CupertinoIcons.arrow_right),
    //                   onPressed: () => controller.toggleSeatHeader(
    //                       1, controller.seatHeaterRight),
    //                   isBinary: false,
    //                 ),
    //               ),
    //             ],
    //           ),
    //           Visibility(
    //             visible: controller.hasRearSeatHeaters.value,
    //             child: Flex(
    //               direction: Axis.horizontal,
    //               children: [
    //                 Expanded(
    //                   child: DearTHeaterButton(
    //                     heaterValue: controller.seatHeaterRearLeft.value,
    //                     icon: const Icon(CupertinoIcons.arrow_left_circle_fill),
    //                     onPressed: () => controller.toggleSeatHeader(
    //                         2, controller.seatHeaterRearLeft),
    //                     isBinary: false,
    //                   ),
    //                 ),
    //                 const SizedBox(
    //                   width: 8,
    //                 ),
    //                 Expanded(
    //                   child: DearTHeaterButton(
    //                     heaterValue: controller.seatHeaterRearCenter.value,
    //                     icon: const Icon(CupertinoIcons.arrow_down_circle_fill),
    //                     onPressed: () => controller.toggleSeatHeader(
    //                         4, controller.seatHeaterRearCenter),
    //                     isBinary: false,
    //                   ),
    //                 ),
    //                 const SizedBox(
    //                   width: 8,
    //                 ),
    //                 Expanded(
    //                   child: DearTHeaterButton(
    //                     heaterValue: controller.seatHeaterRearRight.value,
    //                     icon:
    //                         const Icon(CupertinoIcons.arrow_right_circle_fill),
    //                     onPressed: () => controller.toggleSeatHeader(
    //                         5, controller.seatHeaterRearRight),
    //                     isBinary: false,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  List<Widget> _getLayers() {
    List<Widget> layers = [];
    if (controller.isStreeringWheelHeaterOn.value != null &&
        controller.isStreeringWheelHeaterOn.value!) {
      layers.add(
        const Positioned.fill(
          child: Image(
            image: AssetImage(
              'assets/images/heaters/wheel.png',
            ),
          ),
        ),
      );
    }

    if (controller.seatHeaterLeft.value != null &&
        controller.seatHeaterLeft.value! > 0) {
      layers.add(
        Positioned.fill(
          child: Image(
            image: AssetImage(
              'assets/images/heaters/FL${controller.seatHeaterLeft.value!}.png',
            ),
          ),
        ),
      );
    }

    if (controller.seatHeaterRight.value != null &&
        controller.seatHeaterRight.value! > 0) {
      layers.add(
        Positioned.fill(
          child: Image(
            image: AssetImage(
              'assets/images/heaters/FR${controller.seatHeaterRight.value!}.png',
            ),
          ),
        ),
      );
    }

    if (controller.seatHeaterRearLeft.value != null &&
        controller.seatHeaterRearLeft.value! > 0) {
      layers.add(
        Positioned.fill(
          child: Image(
            image: AssetImage(
              'assets/images/heaters/RL${controller.seatHeaterRearLeft.value!}.png',
            ),
          ),
        ),
      );
    }

    if (controller.seatHeaterRearCenter.value != null &&
        controller.seatHeaterRearCenter.value! > 0) {
      layers.add(
        Positioned.fill(
          child: Image(
            image: AssetImage(
              'assets/images/heaters/RM${controller.seatHeaterRearCenter.value!}.png',
            ),
          ),
        ),
      );
    }

    if (controller.seatHeaterRearRight.value != null &&
        controller.seatHeaterRearRight.value! > 0) {
      layers.add(
        Positioned.fill(
          child: Image(
            image: AssetImage(
              'assets/images/heaters/RR${controller.seatHeaterRearRight.value!}.png',
            ),
          ),
        ),
      );
    }
    return layers;
  }

  void handleTap(TapUpDetails tapDetails) async {
    String? tapHeater =
        findTap(tapDetails.localPosition.dx, tapDetails.localPosition.dy);
    if (tapHeater != null) {
      switch (tapHeater) {
        case "FL":
          await controller.toggleSeatHeader(0, controller.seatHeaterLeft);
          break;
        case "FR":
          await controller.toggleSeatHeader(1, controller.seatHeaterRight);
          break;
        case "RL":
          await controller.toggleSeatHeader(2, controller.seatHeaterRearLeft);
          break;
        case "RM":
          await controller.toggleSeatHeader(4, controller.seatHeaterRearCenter);
          break;
        case "RR":
          await controller.toggleSeatHeader(5, controller.seatHeaterRearRight);
          break;
        case "Wheel":
          await controller.toggleSteeringWheelHeater();
          break;
      }
    }
  }

  void turnAllOff() async {
    if (controller.seatHeaterLeft.value != null &&
        controller.seatHeaterLeft.value! > 0) {
      await controller.toggleSeatHeader(
        0,
        controller.seatHeaterLeft,
        toggleOff: true,
      );
    }

    if (controller.seatHeaterRight.value != null &&
        controller.seatHeaterRight.value! > 0) {
      await controller.toggleSeatHeader(
        1,
        controller.seatHeaterRight,
        toggleOff: true,
      );
    }

    if (controller.seatHeaterRearLeft.value != null &&
        controller.seatHeaterRearLeft.value! > 0) {
      await controller.toggleSeatHeader(
        2,
        controller.seatHeaterRearLeft,
        toggleOff: true,
      );
    }

    if (controller.seatHeaterRearCenter.value != null &&
        controller.seatHeaterRearCenter.value! > 0) {
      await controller.toggleSeatHeader(
        4,
        controller.seatHeaterRearCenter,
        toggleOff: true,
      );
    }

    if (controller.seatHeaterRearRight.value != null &&
        controller.seatHeaterRearRight.value! > 0) {
      await controller.toggleSeatHeader(
        5,
        controller.seatHeaterRearRight,
        toggleOff: true,
      );
    }

    if (controller.isStreeringWheelHeaterOn.value != null &&
        controller.isStreeringWheelHeaterOn.value!) {
      await controller.toggleSteeringWheelHeater(turnOff: true);
    }

    if (controller.isClimateOn.value) {
      await Get.find<VehicleController>().acStop();
    }

    openSnackbar(
      'Seat Heaters',
      'All seat heaters turned off.',
      currentSnackbar: controller.snackBar,
    );
  }

  void handleLongPress(LongPressEndDetails tapDetails) async {
    String? tapHeater =
        findTap(tapDetails.localPosition.dx, tapDetails.localPosition.dy);
    if (tapHeater != null) {
      switch (tapHeater) {
        case "FL":
          await controller.toggleSeatHeader(
            0,
            controller.seatHeaterLeft,
            toggleMax: controller.seatHeaterLeft.value! == 0,
            toggleOff: controller.seatHeaterLeft.value! > 0,
          );
          break;
        case "FR":
          await controller.toggleSeatHeader(
            1,
            controller.seatHeaterRight,
            toggleMax: controller.seatHeaterRight.value! == 0,
            toggleOff: controller.seatHeaterRight.value! > 0,
          );
          break;
        case "RL":
          await controller.toggleSeatHeader(
            2,
            controller.seatHeaterRearLeft,
            toggleMax: controller.seatHeaterRearLeft.value! == 0,
            toggleOff: controller.seatHeaterRearLeft.value! > 0,
          );
          break;
        case "RM":
          await controller.toggleSeatHeader(
            4,
            controller.seatHeaterRearCenter,
            toggleMax: controller.seatHeaterRearCenter.value! == 0,
            toggleOff: controller.seatHeaterRearCenter.value! > 0,
          );
          break;
        case "RR":
          await controller.toggleSeatHeader(
            5,
            controller.seatHeaterRearRight,
            toggleMax: controller.seatHeaterRearRight.value! == 0,
            toggleOff: controller.seatHeaterRearRight.value! > 0,
          );
          break;
        case "Wheel":
          await controller.toggleSteeringWheelHeater();
          break;
      }
    }
  }

  String? findTap(double dx, double dy) {
    List<TapPosition> positions = initPositions();

    TapPosition? tap = positions.firstWhereOrNull((element) =>
        element.x1 <= dx &&
        element.x2 > dx &&
        element.y1 <= dy &&
        element.y2 > dy);

    return tap?.name;
  }

  List<TapPosition> initPositions() {
    List<TapPosition> result = [];
    // FL
    result.add(TapPosition('FL', 178, 219, 98, 138));

    // FR
    result.add(TapPosition('FR', 164, 220, 42, 80));

    // RL
    result.add(TapPosition('RL', 236, 293, 105, 138));

    // RM
    result.add(TapPosition('RM', 236, 293, 79, 104));

    // RR
    result.add(TapPosition('RR', 236, 293, 42, 80));

    // Wheel
    result.add(TapPosition('Wheel', 137, 164, 106, 135));

    return result;
  }
}

class TapPosition {
  final String name;
  final double x1;
  final double x2;
  final double y1;
  final double y2;

  TapPosition(this.name, this.x1, this.x2, this.y1, this.y2);
}
