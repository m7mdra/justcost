import 'dart:math';

import 'package:flutter/material.dart';

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
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
                hintText: 'Search for...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                suffixIcon: Icon(Icons.search)),
          ),
        ),
        Expanded(
          child: GridView(
            primary: false,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            children: <Widget>[
              CategoryWidget(),
              CategoryWidget(),
              CategoryWidget(),
              CategoryWidget(),
              CategoryWidget(),
              CategoryWidget(),
              CategoryWidget(),
              CategoryWidget(),
              CategoryWidget(),
            ],
          ),
        )
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
      width: 200,
      height: 200,
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              width: 200,
              height: 140,
              color: Colors.red,
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Category',
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text('${Random().nextInt(1000)}',
                      style: TextStyle(color: Colors.white)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
