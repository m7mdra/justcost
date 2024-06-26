import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'i10n/app_localizations.dart';
class ImageCropperScreen extends StatefulWidget {
  final File imageFile;

  const ImageCropperScreen({Key key, this.imageFile}) : super(key: key);

  @override
  _ImageCropperScreenState createState() => new _ImageCropperScreenState();
}

class _ImageCropperScreenState extends State<ImageCropperScreen> {
  final cropKey = GlobalKey<CropState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).cropYourImage),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Crop.file(
            widget.imageFile,
            key: cropKey,
            alwaysShowGrid: true,
            maximumScale: 1.0,
            aspectRatio: 1 / 1,
            scale: 1.0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _cropImage(),
        label: Text(AppLocalizations.of(context).cropButton),
        icon: Icon(Icons.crop),
      ),
    );
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;

    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    final sample = await ImageCrop.sampleImage(
      file: widget.imageFile,
      preferredSize: (1000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );
    Navigator.of(context).pop(file);
    sample.delete();
  }
}
