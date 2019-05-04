import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Html(
            padding: const EdgeInsets.all(16),
            customRender: (node, childern) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case 'h1':
                    return Text(
                      node.text,
                      style: Theme.of(context).textTheme.display1,
                    );
                }
              }
            },
            data: """<h1>JustCost</h1> 
            <h2>Privacy Policy</h2>
            """,
          ),
        ),
      ),
    );
  }
}
