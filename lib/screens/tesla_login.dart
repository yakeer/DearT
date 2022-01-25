import 'dart:async';
import 'dart:io';

import 'package:deart/controllers/app_controller.dart';
import 'package:deart/models/internal/login_page_data.dart';
import 'package:deart/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebView extends StatefulWidget {
  final LoginPageData loginPageData;

  const LoginWebView(
    this.loginPageData, {
    Key? key,
  }) : super(key: key);

  @override
  _LoginWebViewState createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      // WebView.platform = SurfaceAndroidWebView();
      // WebView.platform = AndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with Tesla'),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.loginPageData.loginUrl.toString(),
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onProgress: (int progress) {},
            zoomEnabled: false,
            navigationDelegate: (NavigationRequest request) async {
              // Catch Authorization code.
              if (request.url
                  .startsWith('https://auth.tesla.com/void/callback?code=')) {
                Uri uri = Uri.parse(request.url);
                widget.loginPageData.authorizationCode =
                    uri.queryParameters['code']!;

                var loginPageData = await Get.find<AuthService>()
                    .exchangeAuthorizationCodeForBearerToken(
                  widget.loginPageData,
                );

                loginPageData = await Get.find<AuthService>()
                    .exchangeBearerTokenForAccessToken(loginPageData);

                if (loginPageData.loginSuccess) {
                  Get.find<AppController>().isLoggedIn.value = true;
                  Get.offAllNamed('/home');
                }

                return NavigationDecision.prevent;
              }
              // Other navigation
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {
              setState(() {
                isLoading = false;
              });
            },
            gestureNavigationEnabled: false,
            backgroundColor: const Color(0x00000000),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack()
        ],
      ),
    );
  }
}
