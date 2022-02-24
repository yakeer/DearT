import 'package:deart/controllers/logout_controller.dart';
import 'package:deart/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TeslaLogoutScreen extends GetView<LogoutController> {
  final bool logoutOnlyTeslaAccount;

  const TeslaLogoutScreen(
    this.logoutOnlyTeslaAccount, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<LogoutController>(
      init: LogoutController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('${controller.title}'),
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl: Get.find<AuthService>().getLogoutPage().toString(),
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                // controller.webViewController.complete(webViewController);
              },
              onProgress: (int progress) {},
              zoomEnabled: false,
              navigationDelegate: (NavigationRequest request) async {
                // Catch Authorization code.
                if (request.url
                    .startsWith('https://auth.tesla.com/void/callback?code=')) {
                  return NavigationDecision.prevent;
                } else {
                  // Other navigation
                  return NavigationDecision.navigate;
                }
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) async {
                controller.pagesHitCount++;
                if (!logoutOnlyTeslaAccount && controller.pagesHitCount == 2) {
                  // Perform App Logout
                  await Get.find<AuthService>().logout();
                }
              },
              gestureNavigationEnabled: false,
              backgroundColor: const Color(0x00000000),
            ),
          ],
        ),
      ),
    );
  }
}
