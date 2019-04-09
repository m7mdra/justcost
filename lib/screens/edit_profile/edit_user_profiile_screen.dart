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
  bool isUpdate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.all(16),
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
              buildDivider(),
              buildTitle('Personal Information', () {}),
              ListTile(
                  contentPadding: tilePadding(),
                  dense: true,
                  title: Text('Full name'),
                  subtitle: Text('Mega son of himself')),
              ListTile(
                  dense: true, title: Text('Gender'), subtitle: Text('Male')),
              ListTile(
                  contentPadding: tilePadding(),
                  dense: true,
                  title: Text('Address'),
                  subtitle: Text('Provience, City, Address')),
              buildDivider(),
              buildTitle('Account Information', () {}),
              ListTile(
                  contentPadding: tilePadding(),
                  dense: true,
                  title: Text('Username'),
                  subtitle: Text('@Mega')),
              ListTile(
                  contentPadding: tilePadding(),
                  dense: true,
                  title: Text('Email Address'),
                  subtitle: Text('mail@domain.com')),
              buildTitle('Account Security ', () {
                setState(() {
                  isUpdate = !isUpdate;
                });
              }),
              isUpdate
                  ? Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(hintText: 'New Password'),
                        ),
                        TextField(
                          decoration:
                              InputDecoration(hintText: 'Confirm New Password'),
                        ),
                        TextField(
                          decoration:
                              InputDecoration(hintText: 'Current Password'),
                        ),
                        RaisedButton(onPressed: () {})
                      ],
                    )
                  : ListTile(
                      dense: true,
                      contentPadding: tilePadding(),
                      title: Text('Password'),
                      subtitle: Text('**********')),
            ],
          ),
        ],
      )),
    );
  }

  EdgeInsets tilePadding() =>
      const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0);

  Widget buildTitle(String sectionTitle, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(sectionTitle),
        FlatButton(onPressed: onPressed, child: Text('Update'))
      ],
    );
  }

  Divider buildDivider() {
    return const Divider(
      height: 1,
      indent: 0,
    );
  }
}
