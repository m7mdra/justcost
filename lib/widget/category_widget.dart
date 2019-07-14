import 'package:flutter/material.dart';
import 'package:justcost/data/category/model/category.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;
  final ValueChanged<Category> onClick;

  const CategoryWidget({Key key, this.category, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick(category);
      },
      child: Card(
        margin: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            category.image == null || category.image.isEmpty
                ? Container(
                    width: 150,
                    height: 135,
                    color: Colors.red,
                  )
                : Image.network(
                    category.image,
                    width: 150,
                    height: 135,
                  ),
            const SizedBox(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(
                category.name,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
