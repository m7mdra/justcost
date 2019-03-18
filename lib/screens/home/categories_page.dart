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
    return Container(
      child: Center(child: Text('CATEGROIES')),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
