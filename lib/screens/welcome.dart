import 'package:deart/controllers/welcome_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends GetView<WelcomeController> {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(WelcomeController());

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: SizedBox(
                width: 300,
                height: 300,
                child: Image.asset(
                  'assets/images/logo.png',
                ),
              ),
            ),
            Text(
              controller.appName.value,
              style: const TextStyle(
                fontSize: 36,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
