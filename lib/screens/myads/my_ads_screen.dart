import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/ad/ad_repository.dart';
import 'package:justcost/data/ad/model/my_ads_response.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/myad_details/my_ad_details_screen.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';

import 'my_ads_bloc.dart';

class MyAdsScreen extends StatefulWidget {
  @override
  _MyAdsScreenState createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  MyAdsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MyAdsBloc(DependenciesProvider.provide());
    _bloc.dispatch(LoadMyAds());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).myAds),
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, MyAdsState state) {
          if (state is LoadingState || state is IdleState)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (state is NetworkErrorState)
            return Center(
              child: NetworkErrorWidget(onRetry: () {
                _bloc.dispatch(LoadMyAds());
              }),
            );
          if (state is ErrorState)
            return Center(
              child: GeneralErrorWidget(
                onRetry: () {
                  _bloc.dispatch(LoadMyAds());
                },
              ),
            );
          if (state is MyAdsLoadedState) {
            return RefreshIndicator(
              onRefresh: () {
                _bloc.dispatch(LoadMyAds());

                return Future.value(null);
              },
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var ad = state.ads[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyAdDetailsScreen(ad)),
                      );
                    },
                    child: Card(
                        /*child: ListTile(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyAdDetailsScreen(ad)),
                            );
                          },
//                    leading: Text(ad.iswholesale
//                        ? AppLocalizations.of(context).wholesaleAdType
//                        : AppLocalizations.of(context).normalAdType),
                        leading: Column(
                          children: <Widget>[
                            Text('Ad Title'),
                            Text('Ad Description'),
                            Text('Ad Type'),
                            Text('Ad Status'),
                            Text('Ad Approve'),
                          ],
                        ),
                      trailing: _getStatusFromCode(context, ad.status),
                      title: Text(ad.adTitle ??
                          "${AppLocalizations.of(context).adTitleLabel} ${AppLocalizations.of(context).na}"),
                      subtitle: Column(
                        mainAxisSize  : MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(ad.adDescription ??
                              "${AppLocalizations.of(context).adDetailsTitle} ${AppLocalizations.of(context).na}"),
                          Text(
                              '${AppLocalizations.of(context).status}: ${ad.status == 1 ? AppLocalizations.of(context).active : AppLocalizations.of(context).inactive}'),
                          OutlineButton(
                            onPressed: () {},
                            child: ad.status == 1
                                ? Text(AppLocalizations.of(context).disable)
                                : Text(AppLocalizations.of(context).enable),
                            padding: const EdgeInsets.all(0),
                          )
                        ],
                      ),
                      isThreeLine: true,
                    )*/
                        child: Container(
                          margin: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 5,),
                                    Text('${AppLocalizations.of(context).adTitleLabel}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),),
                                    SizedBox(height: 5,),
                                    Text('${AppLocalizations.of(context).adDetailsTitle}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16))),
                                    SizedBox(height: 5,),
                                    Text('${AppLocalizations.of(context).adType}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16))),
                                    SizedBox(height: 5,),
                                    Text('${AppLocalizations.of(context).status}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16))),
                                    SizedBox(height: 5,),
                                    Text('${AppLocalizations.of(context).adApproveStatus}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16))),
                                    SizedBox(height: 5,),
                                  ],
                                ),
                              ),
                              Container(
                                width: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 5,),
                                    Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 15)),),
                                    SizedBox(height: 5,),
                                    Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 15))),
                                    SizedBox(height: 5,),
                                    Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 15))),
                                    SizedBox(height: 5,),
                                    Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 15))),
                                    SizedBox(height: 5,),
                                    Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 15))),
                                    SizedBox(height: 5,),
                                  ],
                                ),
                              ),
                              Container(
                                width: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 5,),
                                    Text('${ad.adTitle}',style: (TextStyle(fontWeight: FontWeight.normal,fontSize: 15)),),
                                    SizedBox(height: 5,),
                                    Text('${ad.adDescription}',style: (TextStyle(fontWeight: FontWeight.normal,fontSize: 15))),
                                    SizedBox(height: 5,),
                                    Text(ad.iswholesale ? AppLocalizations.of(context).wholesaleAdType : AppLocalizations.of(context).normalAdType,style: (TextStyle(fontWeight: FontWeight.normal,fontSize: 15))),
                                    SizedBox(height: 5,),
                                    Text(ad.status == 1 ? AppLocalizations.of(context).active : AppLocalizations.of(context).inactive,style: (TextStyle(fontWeight: FontWeight.normal,fontSize: 15))),
                                    SizedBox(height: 5,),
                                    Text(ad.status == 3 ? AppLocalizations.of(context).adApprovedStatus: ad.status == 2 ? AppLocalizations.of(context).adRejectedStatus : ad.status == 1 ? AppLocalizations.of(context).adPendingStatus : AppLocalizations.of(context).enable,style: (TextStyle(fontWeight: FontWeight.normal,fontSize: 15))),
                                    SizedBox(height: 5,),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: 120,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      ad.status == 3
                                          ?Card(
                                            color: ad.status == 1 ? Colors.red : Colors.green,
                                            child: Container(
                                              width: 100,
                                              height: 40,
                                              child: Center(
                                                child: Text(ad.status == 1 ? 'تعطيل' : 'تفعيل',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 15,color: Colors.white))),
                                              ),
                                            ),
                                          )
                                          :ad.status == 1
                                            ?Container(
                                              width: 100,
                                              height: 40,
                                              margin: EdgeInsets.only(left: 10),
                                              child: Center(
                                                child: Text('الاعلان بانتظار الموافقة',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 15,color: Colors.grey[700])),textAlign: TextAlign.center,),
                                              ),
                                            )
                                            : ad.status == 2
                                             ?Container(
                                              width: 100,
                                              height: 40,
                                              margin: EdgeInsets.only(left: 10),
                                              child: Center(
                                                child: Text('تم رفض إضافة اعلانك',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 15,color: Colors.grey[700])),textAlign: TextAlign.center,),
                                              ),
                                             )
                                             :Container()
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ),
                  );
                },
                itemCount: state.ads.length,
              ),
            );
          }
          if (state is EmptyState) return NoDataWidget();
          return Container();
        },
      ),
    );
  }

  Text _getStatusFromCode(BuildContext context, int status) {
    if (status == 1)
      return Text(
        AppLocalizations.of(context).adPendingStatus,
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      );
    else if (status == 2)
      return Text(
        AppLocalizations.of(context).adRejectedStatus,
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
    else
      return Text(
        AppLocalizations.of(context).adApprovedStatus,
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      );
  }
}
