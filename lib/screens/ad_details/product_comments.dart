import 'package:flutter/material.dart';
import 'package:justcost/data/comment/model/comment.dart';

class ProductComments extends StatefulWidget {
  final List<Comment> comments;

  const ProductComments({Key key, this.comments}) : super(key: key);
  @override
  _ProductCommentsState createState() => _ProductCommentsState();
}

class _ProductCommentsState extends State<ProductComments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: null),);
  }
}
