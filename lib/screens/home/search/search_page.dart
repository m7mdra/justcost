import 'dart:math';

import 'package:flutter/material.dart';
import 'package:justcost/screens/search/search_screen.dart';
import 'package:justcost/widget/sliver_app_bar_header.dart';

class SearchPage extends StatefulWidget {
  final Key key;

  SearchPage({this.key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPersistentHeader(
          delegate: SliverAppBarHeaderDelegate(
            minHeight: 100,
            maxHeight: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  child: Card(
                    child: Center(child: Text('For you')),
                  ),
                ),
                CategoryWidget(),
                CategoryWidget(),
                CategoryWidget(),
                CategoryWidget(),
                CategoryWidget(),
                CategoryWidget(),
              ],
            ),
          ),
        ),
        SliverGrid.count(crossAxisCount: 3,children: <Widget>[
          OfferWidget(),
          OfferWidget(),
          OfferWidget(),
          OfferWidget(),
          OfferWidget(),
          OfferWidget(),
          OfferWidget(),
          OfferWidget(),
          OfferWidget(),
          OfferWidget(),
          OfferWidget(),
          OfferWidget(),
          OfferWidget(),
          OfferWidget(),
          OfferWidget(),
          OfferWidget(),
        ],)
      ],
    );

  }

  @override
  bool get wantKeepAlive => true;
}

class CategoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Card(
          child: GridTile(
        child: Icon(
          Icons.favorite,
          size: 60,
        ),
        footer: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text('Category')),
        ),
      )),
    );
  }
}

class OfferWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.red,
            child: Random().nextInt(2) == 1
                ? Center(
                    child: Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                : Container(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              child: Text('${Random().nextInt(100)}% OFF'),
              color: Colors.yellow,
            ),
          ),
        ],
      ),
    );
  }
}
