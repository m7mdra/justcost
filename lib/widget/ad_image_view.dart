import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef void OnRemove();

class AdImageView extends StatefulWidget {
  final File file;
  final Size size;
  final OnRemove onRemove;
  final bool showRemoveIcon;

  const AdImageView(
      {Key key, this.file, this.size, this.onRemove, this.showRemoveIcon})
      : super(key: key);

  @override
  _AdImageViewState createState() => _AdImageViewState();
}

class _AdImageViewState extends State<AdImageView> {
  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topRight,
        children: <Widget>[
          ClipRRect(
            borderRadius: new BorderRadius.circular(8.0),
            child: Image.file(
              widget.file,
              fit: BoxFit.cover,
              width: widget.size.width,
              height: widget.size.height,
            ),
          ),
          Visibility(
            visible: widget.showRemoveIcon,
            child: Positioned(
              top: -8,
              right: -8,
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
            ),
          )
        ],
      ),
    );
  }
}
