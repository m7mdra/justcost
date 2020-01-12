import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/screens/ad_details/ad_details_screen.dart';
import 'package:justcost/screens/home/home/recent_ads_bloc.dart';
import 'package:justcost/widget/ad_widget.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/i10n/app_localizations.dart';
import '../../dependencies_provider.dart';

class RecentAdsScreen extends StatefulWidget {
  @override
  _RecentAdsScreenState createState() => _RecentAdsScreenState();
}

class _RecentAdsScreenState extends State<RecentAdsScreen> {
  RecentAdsBloc _recentAdsBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _recentAdsBloc = RecentAdsBloc(DependenciesProvider.provide());
    _recentAdsBloc.add(LoadRecentAds());
    _scrollController = ScrollController(keepScrollOffset: true);
//    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        _recentAdsBloc.add(LoadNextPage());
//      }
//    });
  }

  @override
  void close() {
    super.dispose();
    _recentAdsBloc.close();
//    _scrollController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).recentAds),
      ),
      body: BlocBuilder(
        bloc: _recentAdsBloc,
        builder: (BuildContext context, RecentAdsState state) {

          if (state is RecentAdsLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (index >  state.products.length)
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                else
                  return AdWidget(
                    key: ValueKey(state.products[index].productId),
                    product: state.products[index],
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => AdDetailsScreen(
                                product: state.products[index],
                              )));
                    },
                  );
              },
              itemCount: state.hasReachedMax
                  ? state.products.length
                  : state.products.length + 1,
            );
          }

          if (state is RecentAdsNetworkError)
            return Center(
              child: NetworkErrorWidget(
                onRetry: () {
                  _recentAdsBloc.add(LoadRecentAds());
                },
              ),
            );
          if (state is RecentAdsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is RecentAdsError) {
            return Center(
              child: GeneralErrorWidget(
                onRetry: () {
                  _recentAdsBloc.add(LoadRecentAds());
                },
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  ListView buildListView(List<Product> products) {
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (context, index) {
        return AdWidget(
          key: ValueKey(products[index].productId),
          product: products[index],
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AdDetailsScreen(
                      product: products[index],
                    )));
          },
        );
      },
      itemCount: products.length,
    );
  }
}
