import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/ad/ad_repository.dart';
import 'package:justcost/data/ad/model/my_ads_response.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/dependencies_provider.dart';
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
            return ListView.builder(
              itemBuilder: (context, index) {
                var ad = state.ads[index];
                return Card(
                    child: ListTile(
                  leading: Text(ad.iswholesale
                      ? AppLocalizations.of(context).wholesaleAdType
                      : AppLocalizations.of(context).normalAdType),
                  trailing: _getStatusFromCode(context, ad.status),
                  title: Text(ad.adTitle ??
                      "${AppLocalizations.of(context).adTitleLabel} ${AppLocalizations.of(context).na}"),
                  subtitle: Text(ad.adDescription ??
                      "${AppLocalizations.of(context).adDetailsTitle} ${AppLocalizations.of(context).na}"),
                ));
              },
              itemCount: state.ads.length,
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
