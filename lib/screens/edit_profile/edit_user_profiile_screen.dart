import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justcost/image_cropper_screen.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Align(
                child: ClipOval(
                    child: imageFile == null
                        ? Image.asset(
                            'assets/images/default-avatar.png',
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            imageFile,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          )),
              ),
              OutlineButton(
                onPressed: () {
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
                                  var image = await ImagePicker.pickImage(
                                      source: ImageSource.camera);
                                  var croppedImage = await Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              ImageCropperScreen(
                                                imageFile: image,
                                              )));

                                  setState(() {
                                    imageFile = croppedImage;
                                  });
                                },
                              ),
                              ListTile(
                                title: Text('Pick Image from gallery'),
                                leading: Icon(Icons.image),
                                dense: true,
                                onTap: () async {
                                  var image = await ImagePicker.pickImage(
                                      source: ImageSource.gallery);
                                  var croppedImage = await Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              ImageCropperScreen(
                                                imageFile: image,
                                              )));

                                  setState(() {
                                    imageFile = croppedImage;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Text('Update Profile Avatar'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Personal Information'),
                    FlatButton(onPressed: () {}, child: Text('Update'))
                  ],
                ),
              ),
              ListTile(
                  dense: true,
                  title: Text('Full name'),
                  subtitle: Text('not added')),
              ListTile(
                  dense: true,
                  title: Text('Full'),
                  subtitle: Text('not added')),
              ListTile(
                  dense: true,
                  title: Text('Address'),
                  subtitle: Text('Provience, City, Address')),
              buildDivider(),
            ],
          ),
        ],
      )),
    );
  }

  Divider buildDivider() {
    return const Divider(
      height: 1,
    );
  }
}
