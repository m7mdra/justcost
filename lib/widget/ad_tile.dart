import 'package:flutter/material.dart';

class AdTile extends StatelessWidget {
  final String title;
  final String subtitle;

  AdTile({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8),
      dense: true,
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}