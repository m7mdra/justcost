import 'package:flutter/material.dart';
import 'package:justcost/data/category/model/category.dart';
import 'package:justcost/data/user_sessions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
                ? Image.asset(
                    'assets/icon/android/logo-500.png',
                    width: 130,
                    height: 135,
                  )
                : Image.network(
                    category.image,
                    width: 130,
                    height: 135,
                  ),
            const SizedBox(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(
                Localizations.localeOf(context).languageCode == 'ar' ? category.arName : category.name,
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
