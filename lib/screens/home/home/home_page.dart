import 'dart:math';

import 'package:flutter/material.dart';
import 'package:justcost/screens/ad_details/AdDetailsScreen.dart';
import 'package:justcost/widget/icon_text.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<ScrollNotification> onScroll;

  const HomePage({Key key, this.onScroll}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  SwiperController _swiperController;

  @override
  void initState() {
    super.initState();
    _swiperController = SwiperController();
  }

  @override
  void dispose() {
    super.dispose();
    _swiperController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: Swiper(
            autoplay: true,
            pagination: SwiperPagination(),
            viewportFraction: 0.9,
            indicatorLayout: PageIndicatorLayout.SCALE,
            curve: Curves.fastOutSlowIn,
            itemCount: 10,
            duration: 500,
            itemBuilder: (context, index) {
              return Card(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  color: Color.fromARGB(
                      Random().nextInt(255),
                      Random().nextInt(255),
                      Random().nextInt(255),
                      Random().nextInt(255)),
                ),
              );
            },
          ),
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
          constraints: BoxConstraints.tight(
              Size(MediaQuery.of(context).size.width, 225)),
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
            return AdWidget();
          },
          itemCount: 10,
          shrinkWrap: true,
        ),
        Icon(
          Icons.more_horiz,
          color: Colors.grey,
        ),
        const SizedBox(
          height: 100,
        )
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
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Text('Ad name'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('100 AED'),
                IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () {},
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}

class AdWidget extends StatelessWidget {
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
                    Text('Ad name',style: Theme.of(context)
                            .textTheme
                            .subhead
                            .copyWith(color: Colors.black)),
                    const SizedBox(
                      height: 4,
                    ),
                  Text(
                        'Abu Dhabi',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: Colors.black),
                      ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                        '17 Feb 2010',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: Colors.black),
                      ),
                    const SizedBox(
                      height: 4,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '100 AED',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
