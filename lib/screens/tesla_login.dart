import 'package:deart/controllers/login_controller.dart';
import 'package:deart/models/internal/login_page_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TeslaLoginScreen extends GetView<LoginController> {
  final LoginPageData loginPageData;

  const TeslaLoginScreen(
    this.loginPageData, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<LoginController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text('Login with Tesla'),
        ),
        body: Stack(
          children: [
            Visibility(
              visible: !controller.isAuthorizing.value,
              child: WebView(
                initialUrl: loginPageData.loginUrl.toString(),
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  controller.webViewController.complete(webViewController);
                },
                onProgress: (int progress) {},
                zoomEnabled: false,
                navigationDelegate: (NavigationRequest request) async {
                  // Catch Authorization code.
                  if (request.url.startsWith(
                      'https://auth.tesla.com/void/callback?code=')) {
                    controller.navigationRequestURL = request.url;
                    controller.loginPageData = loginPageData;

                    controller.isAuthorizing.value = true;

                    // controller.captureAuthorizationCode(request.url, loginPageData);

                    return NavigationDecision.prevent;
                  } else {
                    // Other navigation
                    return NavigationDecision.navigate;
                  }
                },
                onPageStarted: (String url) {},
                onPageFinished: (String url) {
                  controller.isLoading.value = false;
                },
                gestureNavigationEnabled: false,
                backgroundColor: const Color(0x00000000),
              ),
            ),
            Visibility(
              visible: !controller.isAuthorizing.value,
              child: controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Stack(),
            ),
            Visibility(
              visible: controller.isAuthorizing.value,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Text('Authorizing....'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
