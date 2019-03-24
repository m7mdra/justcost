import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: Image.network(
                'https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_960_720.png',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Ahmed Salah',
                ),
                Text('Membership: GOLDEN'),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: Colors.grey)),
                  child: Row(
                    children: <Widget>[
                      Text('Level 1'),
                      Text(' | '),
                      Text('Votes 199'),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlineButton(
            onPressed: () {},
            child: Text('Edit Profile'),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Account Information',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          dense: true,
          title: Text('Account Type'),
          subtitle: Text("Personal"),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        const Divider(),
        ListTile(
          dense: true,
          title: Text('Total Ads'),
          subtitle: Text("20 ADS"),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        const Divider(),
        ListTile(
          dense: true,
          title: Text('Active Ads'),
          subtitle: Text("25 ADS"),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        const Divider(),
        ListTile(
          dense: true,
          title: Text('Payed Ads'),
          subtitle: Text("20 ADS"),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        const Divider(),
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
        ),
        ListTile(
          dense: true,
          title: Text('About us'),
        ),
        ListTile(
          dense: true,
          title: Text('Get Help'),
        ),
        ListTile(
          dense: true,
          title: Text('Privacy'),
        ),
        ListTile(
          dense: true,
          title: Text('Term of Service'),
        ),
        ListTile(
          dense: true,
          title: Text('Logout'),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
