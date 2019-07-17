import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justcost/model/media.dart';
import 'package:justcost/widget/ad_image_view.dart';
import 'package:justcost/widget/ad_video_view.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';

const MAX_VIDEO_LENGTH = 20000.0;

class AdMediaScreen extends StatefulWidget {
  final List<Media> mediaList;

  const AdMediaScreen({Key key, this.mediaList}) : super(key: key);

  @override
  _AdMediaScreenState createState() => _AdMediaScreenState();
}

class _AdMediaScreenState extends State<AdMediaScreen> {
  List<Media> mediaList = List<Media>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _flutterVideoCompress = FlutterVideoCompress();
  Subscription _subscription;

  bool isEditMode() => widget.mediaList != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode()) mediaList = widget.mediaList;
    _subscription =
        _flutterVideoCompress.compressProgress$.subscribe((progress) {
      print(progress);
      print(_flutterVideoCompress.isCompressing);
    }, onDone: () {
      Navigator.pop(context);
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (context) {
            return RoundedAlertDialog(
              title: Text('Failed to optimized media'),
              content: Text('$error'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context), child: Text('Ok'))
              ],
            );
          });
    }, cancelOnError: true);
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Product Media'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () {
                if (mediaList.length == 4) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Max media upload is 4'),
                    duration: Duration(seconds: 1),
                  ));
                } else
                  showDialog(
                      context: context,
                      builder: (context) {
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
                                  var image = await ImagePicker.pickImage(
                                      source: ImageSource.camera);
                                  if (image != null)
                                    setState(() {
                                      mediaList.add(
                                          Media(file: image, type: Type.Image));
                                    });
                                },
                              ),
                              ListTile(
                                title: Text('Pick Image from gallery'),
                                leading: Icon(Icons.image),
                                dense: true,
                                onTap: () async {
                                  Navigator.pop(context);
                                  var image = await ImagePicker.pickImage(
                                      source: ImageSource.gallery);
                                  if (image != null)
                                    setState(() {
                                      mediaList.add(
                                          Media(file: image, type: Type.Image));
                                    });
                                },
                              ),
                              ListTile(
                                title: Text('Capture Video'),
                                leading: Icon(Icons.videocam),
                                dense: true,
                                onTap: () async {
                                  Navigator.pop(context);
                                  var video = await ImagePicker.pickVideo(
                                      source: ImageSource.camera);
                                  if (video != null) {
                                    await optimizeVideo(video);
                                  } else {
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text(
                                            'Failed to select video, try again')));
                                  }
                                },
                              ),
                              ListTile(
                                title: Text('Pick Video from gallery'),
                                leading: Icon(Icons.video_library),
                                dense: true,
                                onTap: () async {
                                  Navigator.pop(context);
                                  var video = await ImagePicker.pickVideo(
                                      source: ImageSource.gallery);
                                  if (video != null) {
                                    await optimizeVideo(video);
                                  } else {
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text(
                                            'Failed to select video, try again')));
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      });
              })
        ],
      ),
      body: Container(
          child: mediaList.isEmpty
              ? Center(
                  child: Text(
                    'No Media selected.\ntap on the 📷 icon to add.',
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Max Media uploads for this ad is 4 photos/videos. For videos max is length is 20 seconds',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                        itemBuilder: (context, index) {
                          var media = mediaList[index];
                          return media.type == Type.Image
                              ? AdImageView(
                                  showRemoveIcon: true,
                                  file: media.file,
                                  size: Size(200, 200),
                                  key: ObjectKey('object$index'),
                                  onRemove: () {
                                    setState(() {
                                      mediaList.removeAt(index);
                                    });
                                  },
                                )
                              : AdVideoView(
                                  key: ObjectKey('object$index'),
                                  file: media.file,
                                  showRemoveIcon: true,
                                  size: Size(200, 200),
                                  onRemove: () {
                                    setState(() {
                                      mediaList.removeAt(index);
                                    });
                                  },
                                );
                        },
                        itemCount: mediaList.length,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () {
                            if (mediaList == null || mediaList.isEmpty)
                              Navigator.pop(context);
                            else
                              Navigator.pop(context, mediaList);
                          },
                          child: Text('Next'),
                        ),
                      ),
                    )
                  ],
                )),
    );
  }

  Future optimizeVideo(File video) async {
    MediaInfo mediaInfo = await _flutterVideoCompress.getMediaInfo(video.path);
    if (mediaInfo.duration > MAX_VIDEO_LENGTH) {
      showDialog(
          context: _scaffoldKey.currentContext,
          barrierDismissible: false,
          builder: (context) {
            return RoundedAlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Optimizing video for faster upload time...',
                    textAlign: TextAlign.center,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            );
          });
      MediaInfo compressedMediaInfo = await _flutterVideoCompress.compressVideo(
          mediaInfo.path,
          quality: VideoQuality.DefaultQuality,
          startTime: 0,
          includeAudio: true,
          duration: 20);
      if (compressedMediaInfo != null) {
        debugPrint(
            "VIDEO WAS ${compressedMediaInfo.toJson().toString()} AND NOW IS ${mediaInfo.toJson().toString()}");
        Navigator.pop(_scaffoldKey.currentContext);
        setState(() {
          mediaList
              .add(Media(file: compressedMediaInfo.file, type: Type.Video));
        });
      }
    } else {
      setState(() {
        mediaList.add(Media(file: video, type: Type.Video));
      });
    }
  }
}
