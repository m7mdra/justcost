import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/screens/ad_details/ad_details_screen.dart';
import 'package:justcost/screens/home/home/recent_ads_bloc.dart';
import 'package:justcost/widget/ad_widget.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';

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
    _scrollController = ScrollController(keepScrollOffset: true);
    _recentAdsBloc = RecentAdsBloc(DependenciesProvider.provide());
    _recentAdsBloc.dispatch(LoadRecentAds());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _recentAdsBloc.dispatch(LoadNextPage());

      }
    });
    }

  @override
  void dispose() {
    super.dispose();
    _recentAdsBloc.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Ads'),
      ),
      body: BlocBuilder(
        bloc: _recentAdsBloc,
        builder: (BuildContext context, RecentAdsState state) {
          if (state is RecentAdsLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (index >= state.products.length)
                  return Center(
                    child: CircularProgressIndicator(),
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
                  _recentAdsBloc.dispatch(LoadRecentAds());
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
                  _recentAdsBloc.dispatch(LoadRecentAds());
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