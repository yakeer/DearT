import 'package:deart/controllers/home_controller.dart';
import 'package:deart/widgets/car_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClimatePage extends GetView<HomeController> {
  const ClimatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: Stack(
          children: [
            Positioned(
              child: Row(
                children: [
                  const Icon(Icons.thermostat),
                  Text('${controller.outsideTemperature}\u2103')
                ],
              ),
              left: 15,
              top: (Get.mediaQuery.size.height - 300) / 2,
            ),
            const Center(
              // child: SvgPicture.asset(
              //   'assets/images/upper_view.svg',
              //   semanticsLabel: 'Upper view',
              // ),
              child: CarImageWidget(),
            ),
            Align(
              alignment: Alignment.center,
              child: Card(
                color: Color.fromRGBO(Colors.black.red, Colors.black.green,
                    Colors.black.blue, 0.5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.thermostat),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Inside'),
                          Text('${controller.insideTemperature}\u2103'),
                        ],
                      )
                    ],
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
