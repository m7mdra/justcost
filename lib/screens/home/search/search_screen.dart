import 'dart:math';

import 'package:flutter/material.dart';

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
                delegate: _SliverAppBarDelegate(
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
        SizedBox(width: 2,),

        Text('sort'),
      ],
    );
  }

  Row buildChangeView() {
    return Row(
      children: <Widget>[
        Icon(Icons.list),
        SizedBox(width: 2,),

        Text('View'),
      ],
    );
  }

  Row buildFilter() {
    return Row(
      children: <Widget>[
        Icon(Icons.filter_list),
        SizedBox(width: 2,),
        Text('Filter'),
      ],
    );
  }

  Container buildVerticalDivider() {
    return Container(
      height: 60,
      width: 1,
      color: Colors.grey,
    );
  }

  Row buildCityDropDown() {
    return Row(
      children: <Widget>[
        Icon(Icons.place),
        Text('City name'),
        Icon(Icons.arrow_drop_down)
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
