import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justcost/data/ad/model/my_ads_response.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/ad_details/ad_details_screen.dart';
import 'package:justcost/widget/ad_tile.dart';
import 'package:justcost/widget/ad_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';

class MyAdDetailsScreen extends StatefulWidget {
  final Ad ad;

  MyAdDetailsScreen(this.ad,);

  @override
  _MyAdDetailsScreenState createState() => _MyAdDetailsScreenState();
}

class _MyAdDetailsScreenState extends State<MyAdDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الاعلان'),
//        Row(
//          children: <Widget>[
//            Text('تفاصيل الاعلان'),
////            Container(
////              height: 2,
////              width: 10,
////              color: Colors.white,
////            ),
////            Text(
////              '${widget.ad.adTitle}',
////            )
//          ],
//          mainAxisSize: MainAxisSize.min,
//          crossAxisAlignment: CrossAxisAlignment.start,
//          mainAxisAlignment: MainAxisAlignment.start,
//        ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 5),
            child: IconButton(icon: Icon(CupertinoIcons.pen,size: 25,color: Colors.white,), onPressed: null))
      ],
      ),
      body: ListView(children: <Widget>[
        SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'تفاصيل عامة',
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 30,right: 30,top: 5,bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10,),
                              Text('${AppLocalizations.of(context).adTitleLabel}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),),
                              SizedBox(height: 10,),
                              Text('${AppLocalizations.of(context).adDetailsTitle}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16))),
                              SizedBox(height: 10,),
                              Text('${AppLocalizations.of(context).adType}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16))),
                              SizedBox(height: 10,),
                              Text('${AppLocalizations.of(context).status}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16))),
                              SizedBox(height: 10,),
                              Text('${AppLocalizations.of(context).adApproveStatus}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16))),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 5,),
                              Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 20)),),
                              SizedBox(height: 5,),
                              Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 20))),
                              SizedBox(height: 5,),
                              Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 20))),
                              SizedBox(height: 5,),
                              Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 20))),
                              SizedBox(height: 5,),
                              Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 20))),
                              SizedBox(height: 5,),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10,),
                              Text('${widget.ad.adTitle}',style: (TextStyle(fontWeight: FontWeight.normal,fontSize: 15)),),
                              SizedBox(height: 10,),
                              Text('${widget.ad.adDescription}',style: (TextStyle(fontWeight: FontWeight.normal,fontSize: 15))),
                              SizedBox(height: 10,),
                              Text(widget.ad.iswholesale ? AppLocalizations.of(context).wholesaleAdType : AppLocalizations.of(context).normalAdType,style: (TextStyle(fontWeight: FontWeight.normal,fontSize: 15))),
                              SizedBox(height: 10,),
                              Text(widget.ad.status == 1 ? AppLocalizations.of(context).active : AppLocalizations.of(context).inactive,style: (TextStyle(fontWeight: FontWeight.normal,fontSize: 15))),
                              SizedBox(height: 10,),
                              Text(widget.ad.status == 3 ? AppLocalizations.of(context).adApprovedStatus: widget.ad.status == 2 ? AppLocalizations.of(context).adRejectedStatus : widget.ad.status == 1 ? AppLocalizations.of(context).adPendingStatus : AppLocalizations.of(context).enable,style: (TextStyle(fontWeight: FontWeight.normal,fontSize: 15))),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'منتجات الاعلان',
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ],
                    ),
                  ),
                ),

                widget.ad.products.length == 0 ? NoDataWidget():ListView.builder(
                  primary: false,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return AdWidget(
                      product: widget.ad.products[index],
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AdDetailsScreen(
                                  product: widget.ad.products[index],
                                )));
                      },
                    );
                  },
                  itemCount: widget.ad.products.length,
                  shrinkWrap: true,
                ),

              ],
            ))
      ],),
    );
  }
}
