import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  final VoidCallback onLogout;

  const SettingsWidget({Key key, this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Settings',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          dense: true,
          title: Text('Notifications'),
          onTap: () {},
        ),
        ListTile(
          dense: true,
          title: Text('About us'),
          onTap: () {},
        ),
        ListTile(
          dense: true,
          title: Text('Get Help'),
          onTap: () {},
        ),
        ListTile(
          dense: true,
          title: Text('Privacy'),
          onTap: () {},
        ),
        ListTile(
          dense: true,
          title: Text('Term of Service'),
          onTap: () {},
        ),
        ListTile(
          dense: true,
          title: Text('Logout'),
          onTap: () {
            onLogout();
          },
        ),
      ],
    );
  }
}
