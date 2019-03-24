import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef Function OnRemove();

class AdImageView extends StatefulWidget {
  final File file;
  final Size size;
  final OnRemove onRemove;

  const AdImageView({Key key, this.file, this.size, this.onRemove})
      : super(key: key);

  @override
  _AdImageViewState createState() => _AdImageViewState();
}

class _AdImageViewState extends State<AdImageView> {
  @override
  Widget build(BuildContext context) {

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        ClipRRect(
          borderRadius: new BorderRadius.circular(8.0),
          child: Image.file(

            widget.file,

            width: widget.size.width,
            height: widget.size.height,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 85,
          top: -5,
          child: ClipOval(
            child: InkWell(
              onTap: () {
                widget.onRemove();
              },
              child: Container(
                color: Theme.of(context).accentColor,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
