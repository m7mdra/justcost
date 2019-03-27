import 'dart:io';

import 'package:flutter/material.dart';
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
                        ? Image.network(
                            'https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_960_720.png',
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
                onPressed: () {},
                child: Text('Upload Profile Avatar'),
              ),
            ],
          ),
          ListTile(
            title: Text('Full name'),
            subtitle: Text('Person name'),
            trailing: OutlineButton(
              onPressed: () {},
              child: Text('Change'),
            ),
            dense: true,
          ),
          buildDivider(),
          ListTile(
            title: Text('Password'),
            subtitle: Text('*******'),
            trailing: OutlineButton(
              onPressed: () {},
              child: Text('Change'),
            ),
            dense: true,
          ),
          buildDivider(),
          ListTile(
            title: Text('Phone Number'),
            subtitle: Text('+123456879754'),
            trailing: OutlineButton(
              onPressed: () {},
              child: Text('Change'),
            ),
            dense: true,
          ),
          buildDivider(),
          ListTile(
            title: Text('Email Address'),
            subtitle: Text('Mail@domain.com'),
            trailing: OutlineButton(
              onPressed: () {},
              child: Text('Change'),
            ),
            dense: true,
          ),
          buildDivider(),
          ListTile(
            title: Text('Upgrade Account'),
            subtitle: Text('Personal account'),
            trailing: OutlineButton(
              onPressed: () {},
              child: Text('Upgrade'),
            ),
            dense: true,
          ),
          buildDivider(),
          ListTile(
            title: Text('Address'),
            subtitle:
                Text('1st Street, Corniche Road 1435, Dar Al Salam Building'),
            trailing: OutlineButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => RoundedAlertDialog(
                          title: Text('Update your Address'),
                          content: TextField(
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: 'New Address',
                                errorMaxLines: 1,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8))),
                          ),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel')),
                            FlatButton(onPressed: () {}, child: Text('Save')),
                          ],
                        ));
              },
              child: Text('Change'),
            ),
            dense: true,
          ),
          buildDivider(),
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
