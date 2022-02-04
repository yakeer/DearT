import 'dart:async';

import 'package:deart/controllers/app_controller.dart';
import 'package:deart/controllers/user_controller.dart';
import 'package:deart/models/internal/login_page_data.dart';
import 'package:deart/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = RxBool(false);

  // For Access Token Login
  RxString loginWithTokenTitle = RxString('Login with Tokens');
  TextEditingController accessTokenController = TextEditingController();
  TextEditingController refreshTokenController = TextEditingController();

  // For Tesla Login
  RxBool isAuthorizing = RxBool(false);
  final Completer<WebViewController> webViewController =
      Completer<WebViewController>();
  String? navigationRequestURL;
  LoginPageData? loginPageData;

  @override
  void onInit() {
    isAuthorizing.listen((value) {
      captureAuthorizationCode(navigationRequestURL!, loginPageData!);
    });

    super.onInit();
  }

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

  Future<void> captureAuthorizationCode(
      String url, LoginPageData loginPageData) async {
    // Capture authorization Code
    Uri uri = Uri.parse(url);
    loginPageData.authorizationCode = uri.queryParameters['code']!;

    var loginPageDataResult =
        await Get.find<AuthService>().exchangeAuthorizationCodeForBearerToken(
      loginPageData,
    );

    loginPageData = await Get.find<AuthService>()
        .exchangeBearerTokenForAccessToken(loginPageDataResult);

    UserController userController = Get.put(
      UserController(null),
      permanent: true,
    );
    await userController.initVehicles();

    if (loginPageData.loginSuccess) {
      Get.find<AppController>().isLoggedIn.value = true;
      Get.offAllNamed('/home');
    }
  }
}
