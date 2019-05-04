import 'package:flutter/material.dart';
import 'package:justcost/widget/icon_text.dart';

class AdDetailsScreen extends StatefulWidget {
  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ad Details'),
      ),
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            color: Colors.red,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconText(
                  icon: Icon(Icons.flag),
                  text: Text('Report'),
                ),
                IconText(
                  icon: Icon(Icons.favorite),
                  text: Text('Save'),
                ),
                IconText(
                  icon: Icon(Icons.share),
                  text: Text('Share'),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Mobile & Tabs',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 16,
                      color: Colors.grey,
                    ),
                    Text(
                      'Mobile',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 16,
                      color: Colors.grey,
                    ),
                    Text(
                      'OPPO',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                Text('12 Feb, 2018')
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'OPPO Find X Automobile Lamborghini Edition',
                    style: Theme.of(context).textTheme.title,
                    maxLines: 2,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 4, bottom: 4),
                      color: Theme.of(context).accentColor,
                      child: Text(
                        '25% OFF',
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    ),
                    Text(
                      '600 AED',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "OPPO Find X is the world’s first panoramic designed phone,"
                " embracing the beauty of nature into a leading technology product."
                " OPPO Find X combines two seamless pieces of glass with the front screen"
                " featuring a gorgeous panoramic view."),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(right: 32.0, left: 32, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Model'),
                Text('Find X'),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(right: 32.0, left: 32, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Brand'),
                Text('OPPO'),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(right: 32.0, left: 32, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Condition'),
                Text('NEW'),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(right: 32.0, left: 32, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Usage'),
                Text('Never used'),
              ],
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconText(
                icon: Icon(
                  Icons.person,
                  size: 30,
                ),
                text: Text('Mohamed Ali'),
              ),
              Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: IconText(
                      icon: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      text: Text(
                        ' +2499123456789 ',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: IconText(
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      text: Text(
                        ' View Location',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          /* Container(
            width: MediaQuery.of(context).size.width,
            height: 180,
            child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(25.276987, 55.296249), zoom: 13)),
          ),*/
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Text('Rate'),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.star),
                Icon(Icons.star),
                Icon(Icons.star),
                Icon(Icons.star),
                Icon(Icons.star),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Write a comment'),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.5)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () {},
              child: Text('post'),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 300,
            width: MediaQuery.of(context).size.width,
            child: ListView.separated(
                primary: false,
                itemBuilder: (context, index) {
                  return AdComment();
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: 3),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlineButton(
              onPressed: () {},
              child: Text('View more comments'),
            ),
          )
        ],
      )),
    );
  }
}

class AdComment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('user name'),
          Text(
            '12 Feb, 2017',
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
      subtitle: Text(
        'Ever wish you could get the '
        'Cliff Notes for writing popular posts? ',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: 15,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: 15,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: 15,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: 15,
          ),
          Icon(
            Icons.star,
            color: Colors.grey,
            size: 15,
          ),
        ],
      ),
    );
  }
}

class AdCommentReplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('user name'),
          Text(
            '12 Feb, 2017',
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
      subtitle: Text(
        'Ever wish you could get the '
        'Cliff Notes for writing popular posts? ',
      ),
    );
  }
}
