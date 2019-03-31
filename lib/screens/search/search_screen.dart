import 'dart:math';

import 'package:flutter/material.dart';
import 'package:justcost/widget/sliver_app_bar_header.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Card(
          child: TextField(
            decoration: InputDecoration.collapsed(hintText: 'Search').copyWith(
                contentPadding: const EdgeInsets.all(10),
                icon: Icon(Icons.search),
                isDense: true),
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarHeaderDelegate(
                    maxHeight: 60,
                    minHeight: 60,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            buildCityDropDown(),
                            buildVerticalDivider(),
                            buildFilter(),
                            buildVerticalDivider(),
                            buildChangeView(),
                            buildVerticalDivider(),
                            buildSort(),
                          ],
                        ),
                      ),
                    )))
          ];
        },
        body: Card(
          child: Center(
            child: Text("Sample Text"),
          ),
        ),
      ),
    );
  }

  Row buildSort() {
    return Row(
      children: <Widget>[
        Icon(Icons.sort_by_alpha),
        SizedBox(
          width: 2,
        ),
        Text('sort'),
      ],
    );
  }

  Row buildChangeView() {
    return Row(
      children: <Widget>[
        Icon(Icons.list),
        SizedBox(
          width: 2,
        ),
        Text('View'),
      ],
    );
  }

  Widget buildFilter() {
    return InkWell(
      onTap: () {},
      splashColor: Theme.of(context).accentColor,
      child: Row(
        children: <Widget>[
          Icon(Icons.filter_list),
          SizedBox(
            width: 2,
          ),
          Text('Filter'),
        ],
      ),
    );
  }

  Container buildVerticalDivider() {
    return Container(
      height: 60,
      width: 1,
      color: Colors.grey,
    );
  }

  Widget buildCityDropDown() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: <Widget>[
          Icon(Icons.place),
          Text('City name'),
          Icon(Icons.arrow_drop_down)
        ],
      ),
    );
  }
}
