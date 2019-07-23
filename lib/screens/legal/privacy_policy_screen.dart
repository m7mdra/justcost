import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'http://192.168.1.76:8000/privacy_policy.html',
          onPageFinished: (url){
            print('URL: $url');
          },
        ),
      ),
    );
  }
}
