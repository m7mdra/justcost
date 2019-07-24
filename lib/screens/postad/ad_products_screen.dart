import 'package:flutter/material.dart';
import 'package:justcost/model/media.dart';
import 'package:justcost/screens/postad/ad_contact_screen.dart';
import 'package:justcost/screens/postad/ad_details_screen.dart';
import 'package:justcost/screens/postad/ad_review_screen.dart';
import 'package:justcost/widget/ad_image_view.dart';
import 'package:justcost/widget/ad_video_view.dart';

import 'package:justcost/screens/postad/ad.dart';
import 'package:justcost/screens/postad/add_ad_product_screen.dart';
import 'package:justcost/i10n/app_localizations.dart';

enum AdditionType { single, multiple }

class AdProductsScreen extends StatefulWidget {
  final AdditionType additionType;
  final AdDetails adDetails;
  final AdContact adContact;
  final List<AdProduct> products;

  const AdProductsScreen(
      {Key key,
      this.additionType,
      this.adDetails,
      this.adContact,
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
          title: Text(AppLocalizations.of(context).adProducts),
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
                      if (adProduct != null)
                        setState(() {
                          adProducts.add(adProduct);
                        });
                    },
                    icon: Icon(Icons.add),
              tooltip: AppLocalizations.of(context).addProductToolTips,
                  )
          ],
        ),
        body: adProducts.isEmpty
            ? Center(
                child: Text(
                  AppLocalizations.of(context).noProductsAdded,
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return new ProductDismissibleWidget(
                          adProduct: adProducts[index],
                          onDelete: () {
                            adProducts.removeAt(index);
                            setState(() {});
                          },
                          onEdit: () async {
                            var adProduct = await Navigator.push(
                                context,
                                MaterialPageRoute<AdProduct>(
                                    builder: (context) => AddAdProductScreen(
                                          additionType: widget.additionType,
                                          adProduct: adProducts[index],
                                        )));
                            if (adProduct != null)
                              setState(() {
                                adProducts.removeAt(index);
                                adProducts.insert(index, adProduct);
                                print(adProducts);
                              });
                          },
                        );
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
                                          products: adProducts,
                                          additionType: widget.additionType,
                                        )));
                        },
                        child: Text(AppLocalizations.of(context).nextButton),
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
    return Column(
      children: <Widget>[
        ListTile(
          leading: Column(
            children: <Widget>[
              Text(
                "${adProduct.oldPrice} AED",
                style: TextStyle(decoration: TextDecoration.lineThrough),
              ),
              Text(
                "${adProduct.newPrice} AED",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 16),
              )
            ],
          ),
          title: Text(
            adProduct.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(adProduct.details,
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        SizedBox(
          height: 150,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: adProduct.mediaList.length,
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              if (adProduct.mediaList[index].type == Type.Image)
                return AdImageView(
                  showRemoveIcon: false,
                  file: adProduct.mediaList[index].file,
                  size: Size(150, 150),
                );
              else
                return AdVideoView(
                  file: adProduct.mediaList[index].file,
                  showRemoveIcon: false,
                  size: Size(150, 150),
                );
            },
            separatorBuilder: (BuildContext context, int index) {
              return VerticalDivider();
            },
          ),
        ),
      ],
    );
  }
}

class ProductDismissibleWidget extends StatelessWidget {
  const ProductDismissibleWidget({
    Key key,
    @required this.adProduct,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  final AdProduct adProduct;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        child: Dismissible(
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) onDelete();
          },
          background: Container(
            color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.delete_forever),
                ),
              ],
            ),
          ),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Column(
                  children: <Widget>[
                    Text(
                      "${adProduct.oldPrice} AED",
                      style: TextStyle(decoration: TextDecoration.lineThrough),
                    ),
                    Text(
                      "${adProduct.newPrice} AED",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 16),
                    )
                  ],
                ),
                title: Text(
                  adProduct.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(adProduct.details,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: OutlineButton.icon(
                    onPressed: () {
                      onEdit();
                    },
                    icon: Icon(Icons.edit),
                    label: Text(AppLocalizations.of(context).editButton)),
              ),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: adProduct.mediaList.length,
                  padding: const EdgeInsets.all(8),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    if (adProduct.mediaList[index].type == Type.Image)
                      return AdImageView(
                        showRemoveIcon: false,
                        file: adProduct.mediaList[index].file,
                        size: Size(150, 150),
                      );
                    else
                      return AdVideoView(
                        file: adProduct.mediaList[index].file,
                        showRemoveIcon: false,
                        size: Size(150, 150),
                      );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return VerticalDivider();
                  },
                ),
              ),
            ],
          ),
          key: ObjectKey(adProduct.hashCode),
        ),
      ),
    );
  }
}
