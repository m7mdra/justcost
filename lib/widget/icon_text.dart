import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final Icon icon;
  final Text text;

  IconText({this.icon, this.text});

  @override
  Widget build(BuildContext context) {

    return Row(
      children: <Widget>[icon, text],
    );
  }
}
