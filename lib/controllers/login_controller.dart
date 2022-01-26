import 'package:deart/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = RxBool(false);
  RxString loginWithTokenTitle = RxString('Login with Tokens');
  TextEditingController accessTokenController = TextEditingController();
  TextEditingController refreshTokenController = TextEditingController();

  Future saveToken() async {
    if (formKey.currentState!.validate()) {
      Get.showSnackbar(
        const GetSnackBar(
          title: 'Tokens saved successfully',
          message: 'Logging you in...',
          snackPosition: SnackPosition.BOTTOM,
          isDismissible: true,
        ),
      );

      if (!await Get.find<AuthService>().performChangeToken(
        accessTokenController,
        refreshTokenController,
      )) {
        Get.offAllNamed('/login');
      } else {
        Get.offAllNamed('/home');
      }
    }
  }
}
