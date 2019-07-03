import 'package:flutter/material.dart';
import 'package:justcost/data/brand/model/brand.dart';
import 'package:justcost/data/category/model/category.dart';

import 'ad_product.dart';
import 'add_ad_product_screen.dart';

enum AdditionType { single, multiple }

class AdProductsScreen extends StatefulWidget {
  final AdditionType additionType;

  const AdProductsScreen({Key key, this.additionType = AdditionType.single})
      : super(key: key);

  @override
  _AdProductsScreenState createState() => _AdProductsScreenState();
}

class _AdProductsScreenState extends State<AdProductsScreen> {
  List<AdProduct> adProducts = <AdProduct>[
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ad products'),
          actions: <Widget>[
            widget.additionType == AdditionType.single && adProducts.length == 1
                ? Container()
                : IconButton(
                    onPressed: () async {
                      var adProduct = await Navigator.push(
                          context,
                          MaterialPageRoute<AdProduct>(
                              builder: (context) => AddAdProductScreen()));
                      if (adProduct != null) {
                        setState(() {
                          adProducts.add(adProduct);
                        });
                      }
                    },
                    icon: Icon(Icons.add),
                  )
          ],
        ),
        body: adProducts.isEmpty
            ? Center(
                child: Text(
                  'No product added\n Tap on ➕ icon to add product',
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Column(
                      children: <Widget>[
                        Text(
                          "${adProducts[index].oldPrice} AED",
                          style:
                              TextStyle(decoration: TextDecoration.lineThrough),
                        ),
                        Text(
                          "${adProducts[index].newPrice} AED",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 16),
                        )
                      ],
                    ),
                    title: Text(
                      adProducts[index].name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(adProducts[index].details,
                        maxLines: 3, overflow: TextOverflow.ellipsis),
                  );
                },
                itemCount: adProducts.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 1,
                  );
                },
              ));
  }
}
