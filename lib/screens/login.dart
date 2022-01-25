import 'package:deart/controllers/login_controller.dart';
import 'package:deart/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<LoginController>(
      init: LoginController(),
      builder: (controller) {
        bool isLoading = controller.isLoading.value;
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  'Welcome!',
                  style: Get.theme.textTheme.headline2,
                ),
              ),
              Text('How do you wish to login?',
                  style: Get.theme.textTheme.headline5),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => isLoading
                          ? null
                          : Get.find<AuthService>().login(context),
                      child: Text(
                        isLoading ? 'Authorizing...' : 'Tesla Login',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      // onPressed: () => Get.find<AuthService>().changeToken(),
                      onPressed: () => Get.toNamed('/token'),
                      child: const Text(
                        'Access Token',
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.info,
                            size: 32,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'Login credentials are stored in your device only.',
                            style: Get.theme.textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
