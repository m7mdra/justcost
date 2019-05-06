import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final Icon icon;
  final Text text;
  final VoidCallback onPressed;

  IconText({this.icon, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            icon,
            const SizedBox(
              width: 8,
            ),
            text
          ],
        ),
      ),
    );
  }
}
