import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/controllers/home_controller.dart';
import 'package:deart/widgets/main_app_bar.dart';
import 'package:deart/widgets/quick_actions.dart';
import 'package:flutter/material.dart';
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
      Get.find<VehicleController>().refreshState(true);
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

    const appBar = MainAppBar();
    return GetX<HomeController>(
      init: HomeController(),
      builder: (controller) => RefreshIndicator(
        displacement: Get.mediaQuery.size.height / 2,
        backgroundColor: Get.theme.backgroundColor,
        color: Colors.white,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => controller.refreshState(),
        child: Scaffold(
          appBar: appBar,
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: Get.mediaQuery.size.height -
                    appBar.preferredSize.height -
                    Get.mediaQuery.padding.top,
                minHeight: Get.mediaQuery.size.height -
                    appBar.preferredSize.height -
                    Get.mediaQuery.padding.top,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Visibility(
                    visible: controller.selectedPage.value != 2,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: QuickActionsWidget(),
                    ),
                  ),
                  Visibility(
                    visible: controller.isInitialDataLoaded.value,
                    child: Expanded(
                      child: PageView(
                        controller: controller.pageController,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: controller.onPageChanged,
                        children: controller.pages,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.isInitialDataLoaded.value,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicator(),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !controller.isInitialDataLoaded.value,
                    child: Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Waking up car...',
                                  style: Get.theme.textTheme.headline6,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return SizedBox(
      height: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: const Color(0XFF2FB7B2).withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : const BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.circle,
          color: isActive ? const Color(0XFF6BC4C9) : const Color(0XFFEAEAEA),
        ),
      ),
    );
  }

  Widget _settingsIndicator(bool isActive) {
    return SizedBox(
      height: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: const Color(0XFF2FB7B2).withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : const BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.rectangle,
          color: isActive ? const Color(0XFF6BC4C9) : const Color(0XFFEAEAEA),
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < controller.pages.length; i++) {
      if (i == 2) {
        list.add(
          _settingsIndicator(controller.selectedPage.value == 2),
        );
      } else {
        list.add(
          i == controller.selectedPage.value
              ? _indicator(true)
              : _indicator(false),
        );
      }
    }

    return list;
  }
}
