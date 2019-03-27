import 'package:flutter/material.dart';
import 'package:justcost/screens/edit_profile/edit_user_profiile_screen.dart';

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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Text(
              'Ahmed Salah',
            ),
            Text('Membership: GOLDEN'),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  border: Border.all(color: Colors.grey)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Level '),
                  Container(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: Text(
                      ' 19 ',
                      style: TextStyle(color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Colors.black),
                  ),
                  Text(' | '),
                  Text('Votes '),
                  Container(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: Text(
                      '1999',
                      style: TextStyle(color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                        color: Colors.green),
                  ),
                ],
              ),
            ),
            OutlineButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditProfileScreen()));
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
        const Divider(),
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
        ListTile(
          dense: true,
          title: Text('Favorite Ads'),
          subtitle: Text("80 ADS"),
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
