import 'package:flutter/material.dart';

class PlacePickerScreen extends StatefulWidget {
  @override
  _PlacePickerScreenState createState() => _PlacePickerScreenState();
}

class _PlacePickerScreenState extends State<PlacePickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Place'),
      ),
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Dubai'),
            onTap: () {
              Navigator.of(context).pop("Dubai");
            },
          ),
          ListTile(title: Text('Abu Dhabi')),
          ListTile(title: Text('Sharjah')),
          ListTile(title: Text('Ajman')),
          ListTile(title: Text('Ajwoman')),
        ],
      )),
    );
  }
}
