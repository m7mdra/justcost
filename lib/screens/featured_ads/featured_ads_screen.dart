import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/screens/ad_details/ad_details_screen.dart';
import 'package:justcost/screens/home/home/featured_ads_bloc.dart';
import 'package:justcost/screens/home/home/recent_ads_bloc.dart';
import 'package:justcost/widget/ad_widget.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/i10n/app_localizations.dart';
import '../../dependencies_provider.dart';

class FeaturedAdsScreen extends StatefulWidget {
  @override
  _FeaturedAdsScreenState createState() => _FeaturedAdsScreenState();
}

class _FeaturedAdsScreenState extends State<FeaturedAdsScreen> {
  FeaturedAdsBloc _featuredAdsBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _featuredAdsBloc = FeaturedAdsBloc(DependenciesProvider.provide());
    _featuredAdsBloc.dispatch(LoadFeaturedAds());
    _scrollController = ScrollController(keepScrollOffset: true);
//    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        _recentAdsBloc.dispatch(LoadNextPage());
//      }
//    });
  }

  @override
  void dispose() {
    super.dispose();
    _featuredAdsBloc.dispose();
//    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).featuredAds),
      ),
      body: BlocBuilder(
        bloc: _featuredAdsBloc,
        builder: (BuildContext context, FeaturedAdsState state) {
          if (state is FeaturedAdsLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (index >= state.products.length)
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
                  _featuredAdsBloc.dispatch(LoadFeaturedAds());
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
                  _featuredAdsBloc.dispatch(LoadFeaturedAds());
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
