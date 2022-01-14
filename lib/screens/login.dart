import 'package:deart/controllers/login_controller.dart';
import 'package:deart/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('How do you wish to login?',
              style: Get.theme.textTheme.headline5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => Get.find<AuthService>().login(context),
              child: const Text(
                'Tesla Login',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: Get.find<AuthService>().changeToken,
              child: const Text(
                'Access Token',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Text(
                'In either way, your login details are on your local device only.',
                style: Get.theme.textTheme.headline6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
