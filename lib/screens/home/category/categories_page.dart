import 'dart:math';

import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  final Key key;

  CategoriesPage({this.key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with AutomaticKeepAliveClientMixin<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
