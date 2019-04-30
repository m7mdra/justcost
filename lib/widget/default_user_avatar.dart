import 'package:flutter/material.dart';

class DefaultUserAvatarWidget extends StatelessWidget {
  final Size size;
  final String source;

  DefaultUserAvatarWidget(
      [this.source = 'assets/images/default-avatar.png',
      this.size = const Size(90, 90)])
      : super(key: Key(''));
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      source,
      width: size.width,
      height: size.width,
      fit: BoxFit.cover,
    );
  }
}
