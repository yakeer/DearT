import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = RxBool(false);
  RxString loginWithTokenTitle = RxString('Login with Tokens');
  TextEditingController accessTokenController = TextEditingController();
  TextEditingController refreshTokenController = TextEditingController();
}
