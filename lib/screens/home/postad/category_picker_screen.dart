import 'package:flutter/material.dart';

class CategoryPickerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Category")),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          ListTile(
            title: Text("Cars"),
            dense: true,
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: Text("Mobile - Tablet"),
            dense: true,
          ),
          const Divider(),
          ListTile(
            title: Text("Videso Games & Consoles"),
            dense: true,
          ),
          const Divider(),
          ListTile(
            title: Text("Electronics"),
            dense: true,
          ),
          const Divider(),
          ListTile(
            title: Text("Real Estate for Sale"),
            dense: true,
          ),
          const Divider(),
          ListTile(
            title: Text("Real Estate for rent"),
            dense: true,
          ),
          const Divider(),
          ListTile(
            title: Text("Furnitures"),
            dense: true,
          ),
          const Divider(),
          ListTile(
            title: Text("Womenr's Fashion"),
            dense: true,
          ),
          const Divider(),
          ListTile(
            title: Text("Men's Fashion"),
            dense: true,
          ),
          const Divider(),
          ListTile(
            title: Text("Services"),
            dense: true,
          ),
          const Divider(),
          ListTile(
            title: Text("Computers"),
            dense: true,
          ),
        ],
      ),
    );
  }
}
