import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';
import 'package:justcost/model/media.dart';
import 'dart:io';

class MediaPickerDialog extends StatefulWidget {
  final bool showVideo;

  const MediaPickerDialog({Key key, this.showVideo = false}) : super(key: key);

  @override
  _MediaPickerDialogState createState() => _MediaPickerDialogState();
}

class _MediaPickerDialogState extends State<MediaPickerDialog> {
  @override
  Widget build(BuildContext context) {
    return RoundedAlertDialog(
      title: Text('Select Media to add to the uploads'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Capture Image'),
            leading: Icon(Icons.camera_alt),
            dense: true,
            onTap: () async {
              Navigator.pop(context);
              var image =
                  await ImagePicker.pickImage(source: ImageSource.camera);
              var media = Media(file: image, type: Type.Image);
              Navigator.pop(context, media);
            },
          ),
          ListTile(
            title: Text('Pick Image from gallery'),
            leading: Icon(Icons.image),
            dense: true,
            onTap: () async {
              Navigator.pop(context);
              var image =
                  await ImagePicker.pickImage(source: ImageSource.gallery);
              var media = Media(file: image, type: Type.Image);
              Navigator.pop(context, media);
            },
          ),
          Visibility(
            visible: widget.showVideo,
            child: ListTile(
              title: Text('Capture Video'),
              leading: Icon(Icons.videocam),
              dense: true,
              onTap: () async {
                Navigator.pop(context);
                var video =
                    await ImagePicker.pickVideo(source: ImageSource.camera);
                var media = Media(file: video, type: Type.Video);
                Navigator.pop(context, media);
              },
            ),
          ),
          Visibility(
            visible: widget.showVideo,
            child: ListTile(
              title: Text('Pick Video from gallery'),
              leading: Icon(Icons.video_library),
              dense: true,
              onTap: () async {
                Navigator.pop(context);
                var video =
                    await ImagePicker.pickVideo(source: ImageSource.gallery);
                var media = Media(file: video, type: Type.Video);
                Navigator.pop(context, media);
              },
            ),
          ),
        ],
      ),
    );
  }
}
