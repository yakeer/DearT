import 'package:get/get.dart';

class Constants {
  static String baseURL = 'https://owner-api.teslamotors.com';
  static String authBaseURL = 'https://auth.tesla.com';
  static String teslaAPIClientID = "ownerapi";
  static String teslaAuthScopes = "openid email offline_access";
  static double pageControllerHeight = (Get.mediaQuery.size.height - 250);
}
