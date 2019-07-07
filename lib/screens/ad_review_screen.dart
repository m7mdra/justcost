import 'package:flutter/material.dart';

import 'ad_product.dart';

class AdReviewScreen extends StatefulWidget {
  final Ad ad;

  const AdReviewScreen({Key key, this.ad}) : super(key: key);

  @override
  _AdReviewScreenState createState() => _AdReviewScreenState();
}

class _AdReviewScreenState extends State<AdReviewScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.ad);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review your Ad'),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Ad Details',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                OutlineButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {},
                  child: Text('EDIT'),
                  textTheme: ButtonTextTheme.normal,
                )
              ],
            ),
          ),
          Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  dense: true,
                  title: Text('Ad Title'),
                  subtitle: Text(widget.ad.title),
                ),
                divider(),
                ListTile(
                  dense: true,
                  title: Text('Ad Keyword'),
                  subtitle: Text(widget.ad.keyword),
                ),
                divider(),
                ListTile(
                  dense: true,
                  title: Text('Ad Description'),
                  subtitle: Text(widget.ad.description),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Ad Conatact & Location',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                OutlineButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {},
                  child: Text('EDIT'),
                  textTheme: ButtonTextTheme.normal,
                )
              ],
            ),
          ),
          Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  dense: true,
                  title: Text('Phone Number'),
                  subtitle: Text(
                      "+${widget.ad.country.code} ${widget.ad.phoneNumber}"),
                ),
                divider(),
                ListTile(
                  dense: true,
                  title: Text('Email Address'),
                  subtitle: Text(widget.ad.email),
                ),
                divider(),
                ListTile(
                  dense: true,
                  title: Text('Country & City'),
                  subtitle: Text(
                      "${widget.ad.country.name} - ${widget.ad.city.name}"),
                ),
                divider(),
                ListTile(
                  dense: true,
                  title: Text('Facebook account'),
                  subtitle: Text("${widget.ad.facebookPage} "),
                ),
                divider(),
                ListTile(
                  dense: true,
                  title: Text('Instagram account'),
                  subtitle: Text("${widget.ad.instagramPage} "),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Divider divider() {
    return const Divider(
      height: 1,
    );
  }
}
