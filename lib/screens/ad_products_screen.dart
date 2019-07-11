import 'package:flutter/material.dart';
import 'package:justcost/model/media.dart';
import 'package:justcost/screens/ad_contact_screen.dart';
import 'package:justcost/screens/ad_details_screen.dart';
import 'package:justcost/screens/ad_review_screen.dart';

import 'ad.dart';
import 'add_ad_product_screen.dart';

enum AdditionType { single, multiple }

class AdProductsScreen extends StatefulWidget {
  final AdditionType additionType;
  final AdDetails adDetails;
  final AdContact adContact;
  final List<Media> mediaList;
  final List<AdProduct> products;

  const AdProductsScreen(
      {Key key,
      this.additionType,
      this.adDetails,
      this.adContact,
      this.mediaList,
      this.products})
      : super(key: key);

  @override
  _AdProductsScreenState createState() => _AdProductsScreenState();
}

class _AdProductsScreenState extends State<AdProductsScreen> {
  List<AdProduct> adProducts = <AdProduct>[];

  bool isEditMode() => widget.products != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode()) adProducts = widget.products;
  }

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
                              builder: (context) => AddAdProductScreen(
                                  additionType: widget.additionType)));
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
            : Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return new ProductWidget(adProduct: adProducts[index]);
                      },
                      itemCount: adProducts.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          height: 1,
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (isEditMode())
                            Navigator.pop(context, adProducts);
                          else
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute<Ad>(
                                    builder: (context) => AdReviewScreen(
                                          adDetails: widget.adDetails,
                                          adContact: widget.adContact,
                                          mediaList: widget.mediaList,
                                          products: adProducts,
                                        )));
                        },
                        child: Text('Next'),
                      ),
                    ),
                  )
                ],
              ));
  }
}

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    Key key,
    @required this.adProduct,
  }) : super(key: key);

  final AdProduct adProduct;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        children: <Widget>[
          Text(
            "${adProduct.oldPrice} AED",
            style: TextStyle(decoration: TextDecoration.lineThrough),
          ),
          Text(
            "${adProduct.newPrice} AED",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
          )
        ],
      ),
      title: Text(
        adProduct.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle:
          Text(adProduct.details, maxLines: 2, overflow: TextOverflow.ellipsis),
    );
  }
}
