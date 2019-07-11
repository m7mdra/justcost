import 'package:flutter/material.dart';
import 'package:justcost/model/media.dart';
import 'package:justcost/screens/ad_contact_screen.dart';
import 'package:justcost/widget/ad_image_view.dart';
import 'package:justcost/widget/ad_video_view.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';

import 'ad.dart';
import 'ad_details_screen.dart';
import 'ad_media_screen.dart';
import 'ad_products_screen.dart';

class AdReviewScreen extends StatefulWidget {
  final AdDetails adDetails;
  final AdContact adContact;
  final List<Media> mediaList;
  final List<AdProduct> products;
  final AdditionType additionType;

  const AdReviewScreen(
      {Key key,
      this.adDetails,
      this.adContact,
      this.mediaList,
      this.products,
      this.additionType})
      : super(key: key);

  @override
  _AdReviewScreenState createState() => _AdReviewScreenState();
}

class _AdReviewScreenState extends State<AdReviewScreen> {
  AdDetails adDetails;
  AdContact adContact;
  List<Media> mediaList;
  List<AdProduct> products;

  @override
  void initState() {
    super.initState();
    print(widget.additionType);
    adDetails = widget.adDetails;
    adContact = widget.adContact;
    mediaList = widget.mediaList;
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
              padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Ad Details',
                    style: Theme.of(context).textTheme.subtitle,
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
              padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Ad Conatact & Location',
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                  OutlineButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () async {
                      var contact = await Navigator.push(
                          context,
                          MaterialPageRoute<AdContact>(
                              builder: (context) => AdContactScreen(
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
                  AdTile(
                    title: 'Facebook account',
                    subtitle: "${adContact.facebookPage} ",
                  ),
                  divider(),
                  AdTile(
                    title: 'Instagram account',
                    subtitle: "${adContact.instagramPage} ",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Ad Media',
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                  OutlineButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () async {
                      var medias = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdMediaScreen(
                                    mediaList: mediaList,
                                  )));
                      if (medias != null)
                        setState(() {
                          this.mediaList = medias;
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
              child: SizedBox(
                height: 180,
                child: ListView.separated(
                  itemCount: mediaList.length,
                  padding: const EdgeInsets.all(8),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    if (mediaList[index].type == Type.Image)
                      return AdImageView(

                        showRemoveIcon: false,
                        file: mediaList[index].file,
                        size: Size(150, 150),
                      );
                    else
                      return AdVideoView(
                        file: mediaList[index].file,
                        showRemoveIcon: false,
                        size: Size(150, 150),
                      );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return VerticalDivider();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Ad Products',
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                  OutlineButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () async {
                      var products = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdProductsScreen(
                                    products: this.products,
                                    additionType: widget.additionType,
                                  )));
                    },
                    child: Text('EDIT'),
                    textTheme: ButtonTextTheme.normal,
                  )
                ],
              ),
            ),
            ListView.separated(
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
            )
          ],
        )),
        onWillPop: () async {
          bool dismiss = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (context) => RoundedAlertDialog(
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
