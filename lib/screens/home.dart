import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/controllers/home_controller.dart';
import 'package:deart/widgets/main_app_bar.dart';
import 'package:deart/widgets/theme/deart_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> with WidgetsBindingObserver {
  HomeScreen({Key? key}) : super(key: key) {
    WidgetsBinding.instance!.addObserver(this);
  }

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // user returned to our app
      Get.find<VehicleController>().refreshState();
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
    } else if (state == AppLifecycleState.paused) {
      // user quit our app temporally
    } else if (state == AppLifecycleState.detached) {
      // app suspended
    }
    super.didChangeAppLifecycleState(state);
  }

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
      builder: (controller) => RefreshIndicator(
        displacement: Get.mediaQuery.size.height / 2,
        backgroundColor: Get.theme.backgroundColor,
        color: Colors.white,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => Get.find<VehicleController>().refreshState(),
        child: Scaffold(
          appBar: const MainAppBar(),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
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
                Padding(
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
                        top: 245,
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
                        top: 245,
                      ),
                      Positioned(
                        child: Icon(
                          controller.carLocked.value
                              ? Icons.lock
                              : Icons.lock_open,
                          size: 36,
                        ),
                        left: Get.mediaQuery.size.width / 2 - 28,
                        top: 45,
                      ),
                    ],
                  ),
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
                        '${controller.sentryModeStateText}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
