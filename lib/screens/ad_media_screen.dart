import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justcost/model/media.dart';
import 'package:justcost/widget/ad_image_view.dart';
import 'package:justcost/widget/ad_video_view.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';

import 'ad_contact_screen.dart';
import 'ad_details_screen.dart';
import 'ad_type_screen.dart';

class AdMediaScreen extends StatefulWidget {
  final AdDetails adDetails;
  final AdContact adContact;
  final List<Media> mediaList;

  const AdMediaScreen({Key key, this.adDetails, this.adContact, this.mediaList})
      : super(key: key);

  @override
  _AdMediaScreenState createState() => _AdMediaScreenState();
}

class _AdMediaScreenState extends State<AdMediaScreen> {
  List<Media> mediaList = List<Media>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isEditMode() => widget.mediaList != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode()) mediaList = widget.mediaList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Ad Media'),
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
                                  if (video != null)
                                    setState(() {
                                      mediaList.add(
                                          Media(file: video, type: Type.Video));
                                    });
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
                                  if (video != null)
                                    setState(() {
                                      mediaList.add(
                                          Media(file: video, type: Type.Video));
                                    });
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
                        'Max Media uploads for this ad is 4 photos/videos',
                        style: TextStyle(
                            color: Colors.deepOrange,
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
                            if (isEditMode())
                              Navigator.pop(context, mediaList);
                            else
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => AdTypeSelectScreen(
                                            adContact: widget.adContact,
                                            adDetails: widget.adDetails,
                                            mediaList: mediaList,
                                          )));
                          },
                          child: Text('Next'),
                        ),
                      ),
                    )
                  ],
                )),
    );
  }
}
