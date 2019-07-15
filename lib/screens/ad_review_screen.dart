import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:justcost/model/media.dart';
import 'package:justcost/screens/ad_contact_screen.dart';
import 'package:justcost/widget/ad_image_view.dart';
import 'package:justcost/widget/ad_video_view.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';
import 'dart:convert';
import 'ad.dart';
import 'ad_details_screen.dart';
import 'product_media_screen.dart';
import 'ad_products_screen.dart';

class AdReviewScreen extends StatefulWidget {
  final AdDetails adDetails;
  final AdContact adContact;
  final List<AdProduct> products;
  final AdditionType additionType;

  const AdReviewScreen({Key key,
    this.adDetails,
    this.adContact,
    this.products,
    this.additionType})
      : super(key: key);

  @override
  _AdReviewScreenState createState() => _AdReviewScreenState();
}

class _AdReviewScreenState extends State<AdReviewScreen> {
  AdDetails adDetails;
  AdContact adContact;
  List<AdProduct> products;

  @override
  void initState() {
    super.initState();
    print(widget.additionType);
    adDetails = widget.adDetails;
    adContact = widget.adContact;
    products = widget.products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review your Ad'),
      ),
      body: WillPopScope(
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Ad Details',
                        style: Theme
                            .of(context)
                            .textTheme
                            .subtitle,
                      ),
                      OutlineButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () async {
                          var newAdDetails = await Navigator.push(
                              context,
                              MaterialPageRoute<AdDetails>(
                                  builder: (BuildContext context) =>
                                      AdDetailsScreen(
                                        adDetails: adDetails,
                                      )));
                          if (newAdDetails != null) {
                            setState(() {
                              this.adDetails = newAdDetails;
                            });
                          }
                        },
                        child: Text('EDIT'),
                        textTheme: ButtonTextTheme.normal,
                      )
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      AdTile(
                        title: 'Ad Title',
                        subtitle: adDetails.title,
                      ),
                      divider(),
                      AdTile(
                        title: 'Ad Keyword',
                        subtitle: adDetails.keyword,
                      ),
                      divider(),
                      AdTile(
                        title: 'Ad Description',
                        subtitle: adDetails.description,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Ad Conatact & Location',
                        style: Theme
                            .of(context)
                            .textTheme
                            .subtitle,
                      ),
                      OutlineButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () async {
                          var contact = await Navigator.push(
                              context,
                              MaterialPageRoute<AdContact>(
                                  builder: (context) =>
                                      AdContactScreen(
                                        adContact: adContact,
                                      )));
                          if (contact != null)
                            setState(() {
                              this.adContact = contact;
                            });
                        },
                        child: Text('EDIT'),
                        textTheme: ButtonTextTheme.normal,
                      )
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      AdTile(
                        title: 'Phone Number',
                        subtitle:
                        "+${adContact.country.code} ${adContact.phoneNumber}",
                      ),
                      divider(),
                      AdTile(
                        title: 'Email Address',
                        subtitle: adContact.email,
                      ),
                      divider(),
                      AdTile(
                        title: 'Country & City',
                        subtitle:
                        "${adContact.country.name} - ${adContact.city.name}",
                      ),
                      divider(),
                      Visibility(
                        visible: adContact.facebookPage != null &&
                            adContact.facebookPage.isNotEmpty,
                        child: AdTile(
                          title: 'Facebook account',
                          subtitle: "${adContact.facebookPage} ",
                        ),
                      ),
                      divider(),
                      Visibility(
                        visible: adContact.instagramPage != null &&
                            adContact.instagramPage.isNotEmpty,
                        child: AdTile(
                          title: 'Instagram account',
                          subtitle: "${adContact.instagramPage} ",
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Ad Products',
                        style: Theme
                            .of(context)
                            .textTheme
                            .subtitle,
                      ),
                      OutlineButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () async {
                          var products = await Navigator.push(
                              context,
                              MaterialPageRoute<List<AdProduct>>(
                                  builder: (context) =>
                                      AdProductsScreen(
                                        products: this.products,
                                        additionType: widget.additionType,
                                      )));
                          if (products != null && products.isNotEmpty)
                            this.products = products;
                        },
                        child: Text('EDIT'),
                        textTheme: ButtonTextTheme.normal,
                      )
                    ],
                  ),
                ),
                Card(
                  child: ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: products.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 1,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return ProductWidget(
                        adProduct: products[index],
                      );
                    },
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: RaisedButton(
                      onPressed: () async {
                        var ad = Ad(
                            adContact: adContact,
                            adDetails: adDetails,
                            isWholeSale: false,
                            adProducts: products);
                        var client = Dio();
                        client.interceptors.add(LogInterceptor(
                          request: true,
                          responseBody: true,
                          requestHeader: true,
                          error: true,
                          requestBody: true,
                          responseHeader: true,
                        ));
                        var data = FormData.from({
                          'isWholeSale': true,
                          'title': ad.adDetails.title,
                          'keyword': ad.adDetails.keyword,
                          'description': ad.adDetails.description,
                          "country": adContact.country.id,
                          "city": adContact.city.id,
                          "location":
                          "${adContact.location.latitude},${adContact.location
                              .longitude}",
                          "phoneNumber": adContact.phoneNumber,
                          "email": adContact.email,
                          "facebookPage": adContact.facebookPage,
                          "instagramPage": adContact.instagramPage,
                          "product": ad.adProducts.map((product) =>
                              FormData.from({
                                'name': product.name,
                                'quantity': product.quantity,
                                'oldPrice': product.oldPrice,
                                'newPrice': product.newPrice,
                                "category": product.category.id,
//                                'brand': product.brand.id,
                                'details': product.details,
                                'attribute': product.attributes
                                    .map((attr) => attr.id)
                                    .toList(),
                                'media': product.mediaList
                                    .map((media) =>
                                    UploadFileInfo(media.file, media.file.path))
                                    .toList()
                              })).toList()
                        });
                        data.forEach((key, value) {
                          print("[$key]=>${value.runtimeType}");
                        });
                        (data['product'] as List<FormData>).forEach((form) =>
                            form.forEach((key, value) {
                              print("[$key]=>${value.runtimeType}");
                            }));
                        var response = await client.post(
                            'http://192.168.1.69:8000/api/addtest',
                            data: data);
                        print(response);
                      },
                      child: Text('Submit'),
                    ),
                  ),
                )
              ],
            )),
        onWillPop: () async {
          bool dismiss = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  RoundedAlertDialog(
                    title: Text('Discard data?'),
                    content: Text('Are you sure?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                    ],
                  ));
          return Future.value(dismiss);
        },
      ),
    );
  }

  Divider divider() {
    return const Divider(
      height: 1,
    );
  }
}

class AdTile extends StatelessWidget {
  final String title;
  final String subtitle;

  AdTile({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8),
      dense: true,
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
