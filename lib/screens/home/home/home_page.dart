import 'package:flutter/material.dart';
import 'package:justcost/screens/ad_details/AdDetailsScreen.dart';
import 'package:justcost/widget/icon_text.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<ScrollNotification> onScroll;

  const HomePage({Key key, this.onScroll}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        CarouselSlider(
          autoPlay: true,
          height: 200.0,
          aspectRatio: 16 / 9,
          enlargeCenterPage: true,
          viewportFraction: 1.0,
          initialPage: 0,
          items: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Colors.red,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Colors.blue,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Colors.yellow,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Colors.green,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Featured Categories',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          height: 120,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return FeatureCategoryWidget();
            },
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Featured Ads',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          height: 215,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return FeaturedAdsWidget();
            },
            itemCount: 10,
            scrollDirection: Axis.horizontal,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Recent Ads',
            style: TextStyle(fontSize: 18),
          ),
        ),
        ListView.builder(
          primary: false,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return RecentAdsWidget();
          },
          itemCount: 10,
          shrinkWrap: true,
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FeatureCategoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Card(
          child: GridTile(
        child: Icon(
          Icons.favorite,
          size: 70,
        ),
        footer: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text('Category')),
        ),
      )),
    );
  }
}

class FeaturedAdsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        width: 150,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 140,
                    color: Colors.red,
                  ),
                  Container(
                    color: Colors.yellowAccent,
                    child: Text('10% OFF'),
                  )
                ],
              ),
              Text('Ad name'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('100 AED'),
                  IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () {},
                  )
                ],
              )
            ],
          ),
        ));
  }
}

class RecentAdsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AdDetailsScreen()));
      },
      child: Card(
        child: Row(
          children: <Widget>[
            Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                ),
                Container(
                  color: Colors.yellow,
                  child: Text('10% OFF'),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Ad name'),
                    const SizedBox(
                      height: 4,
                    ),
                    IconText(
                      icon: Icon(
                        Icons.place,
                        size: 16,
                      ),
                      text: Text(
                        'Abu Dhabi',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    IconText(
                      icon: Icon(
                        Icons.access_time,
                        size: 16,
                      ),
                      text: Text(
                        '17 Feb 2010',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconText(
                          icon: Icon(Icons.call, size: 13),
                          text: Text(
                            'Call ',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        IconText(
                          icon: Icon(Icons.mode_comment, size: 13),
                          text: Text(
                            'Comment ',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        IconText(
                          icon: Icon(Icons.person, size: 13),
                          text: Text(
                            'Person ',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Text(
                  '100 AED',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
