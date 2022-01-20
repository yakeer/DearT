import 'dart:async';
import 'dart:io';

import 'package:deart/models/internal/login_page_data.dart';
import 'package:flutter/material.dart';
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
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebView(
          initialUrl: widget.loginPageData.loginUrl.toString(),
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            // print('WebView is loading (progress : $progress%)');
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url
                .startsWith('https://auth.tesla.com/void/callback?code=')) {
              Uri uri = Uri.parse(request.url);
              widget.loginPageData.authorizationCode =
                  uri.queryParameters['code']!;
              Navigator.of(context).pop();
            }

            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            // print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            // print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
          backgroundColor: const Color(0x00000000),
        ),
        isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack()
      ],
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
