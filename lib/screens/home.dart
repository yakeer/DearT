import 'package:deart/controllers/car_controller.dart';
import 'package:deart/controllers/home_controller.dart';
import 'package:deart/widgets/battery.dart';
import 'package:deart/widgets/theme/deart_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return GetX<HomeController>(
      init: HomeController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Get.find<CarController>().vehicleName.value),
              BatteryWidget(
                chargeState: controller.chargeState.value,
              ),
              IconButton(
                  onPressed: controller.goToSettings,
                  icon: const Icon(Icons.settings))
            ],
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DearTIconButtton(
                        onTap: controller.turnOnSentry,
                        icon: Icons.add_moderator_outlined,
                        label: 'Arm',
                      ),
                      DearTIconButtton(
                        onTap: controller.turnOffSentry,
                        icon: Icons.remove_moderator_outlined,
                        label: 'Disarm',
                      ),
                      DearTIconButtton(
                        onTap: controller.horn,
                        icon: Icons.volume_down_outlined,
                        label: 'Horn',
                      ),
                      DearTIconButtton(
                        onTap: controller.flashLights,
                        icon: Icons.flourescent_outlined,
                        label: 'Flash',
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/upper_view.svg',
                  semanticsLabel: 'Upper view',
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sentry Mode State: ',
                      ),
                      Text(
                        controller.commandStatus.value,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
