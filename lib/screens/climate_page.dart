import 'package:deart/constants.dart';
import 'package:deart/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ClimatePage extends GetView<HomeController> {
  const ClimatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(8.0),
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
            Center(
              child: SvgPicture.asset(
                'assets/images/upper_view.svg',
                semanticsLabel: 'Upper view',
              ),
            ),
            Positioned(
              child: Row(
                children: [
                  const Icon(Icons.thermostat),
                  Text('${controller.insideTemperature}\u2103')
                ],
              ),
              left: Get.mediaQuery.size.width / 2 - 45,
              top: (Constants.pageControllerHeight) / 2,
            ),
          ],
        ),
      ),
    );
  }
}
