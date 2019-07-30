import 'package:flutter/material.dart';
import 'package:justcost/data/ad/model/my_ads_response.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/widget/ad_tile.dart';

class MyAdDetailsScreen extends StatefulWidget {
  final Ad ad;

  MyAdDetailsScreen(this.ad);

  @override
  _MyAdDetailsScreenState createState() => _MyAdDetailsScreenState();
}

class _MyAdDetailsScreenState extends State<MyAdDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text('My ad details'),
            Text(
              '${widget.ad.adTitle}',
              style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white30),
            )
          ],
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      ),
      body: ListView(children: <Widget>[
        SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).adDetailsTitle,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      OutlineButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () async {


                        },
                        child: Text(AppLocalizations.of(context).editButton),
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
                        title: AppLocalizations.of(context).adTitleLabel,
                        subtitle: widget.ad.adTitle,
                      ),

                      AdTile(
                        title: AppLocalizations.of(context).adDetailsTitle,
                        subtitle: widget.ad.adDescription,
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
                        AppLocalizations.of(context).adContactNLocation,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      OutlineButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () async {

                        },
                        child: Text(AppLocalizations.of(context).editButton),
                        textTheme: ButtonTextTheme.normal,
                      )
                    ],
                  ),
                ),


              ],
            ))
      ],),
    );
  }
}
