import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/screens/ad_details/ad_details_screen.dart';
import 'package:justcost/screens/ad_status_screen.dart';
import 'package:justcost/screens/category_details/category_details.dart';
import 'package:justcost/screens/home/category/categores_bloc.dart';
import 'package:justcost/screens/home/home/recent_ads_bloc.dart';
import 'package:justcost/widget/discount_badge_widget.dart';

import '../../../dependencies_provider.dart';

class SearchPage extends StatefulWidget {
  final Key key;

  SearchPage({this.key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  CategoriesBloc _categoriesBloc;
  RecentAdsBloc _recentAdsBloc;
  List<Product> products;

  @override
  void initState() {
    super.initState();
    _categoriesBloc = CategoriesBloc(DependenciesProvider.provide());
    _recentAdsBloc = RecentAdsBloc(DependenciesProvider.provide());

    _categoriesBloc.dispatch(FetchCategoriesEvent());
    _recentAdsBloc.dispatch(LoadRecentAds());
    _recentAdsBloc.state.listen((state) {
      if (state is RecentAdsLoaded)
        setState(() {
          products = state.products;
        });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _categoriesBloc.dispose();
    _recentAdsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: <Widget>[
        BlocBuilder(
          bloc: _categoriesBloc,
          builder: (BuildContext context, CategoriesState state) {
            if (state is CategoriesLoadedState) {
              state.categories.shuffle();
              return Container(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      height: 120,
                      width: 120,
                      child: Card(
                        child: Center(
                          child: Text(
                            'For you',
                            style: Theme.of(context).textTheme.subhead,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 120,
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CategoryDetailsScreen(
                                        false,
                                        category: state.categories[index],
                                      )));
                            },
                            child: Container(
                              height: 120,
                              width: 120,
                              child: Card(
                                  child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  state.categories[index].image == null ||
                                          state.categories[index].image.isEmpty
                                      ? Container(
                                          height: 70,
                                          width: 70,
                                        )
                                      : Image.network(
                                          state.categories[index].image,
                                          height: 70,
                                          width: 70,
                                        ),
                                  Text(
                                    state.categories[index].name,
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              )),
                            ),
                          );
                        },
                        itemCount: state.categories.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
        BlocBuilder(
          bloc: _recentAdsBloc,
          builder: (BuildContext context, RecentAdsState state) {
            if (state is RecentAdsLoaded) {
              return GridView.builder(
                primary: false,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => AdStatusScreen(
                                products: state.products,
                                position: index,
                              )));
                    },
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        state.products[index].media[0].url != null &&
                                state.products[index].media[0].url.isNotEmpty
                            ? Image.network(
                                state.products[index].media[0].url,
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                              )
                            : Container(
                                width: 120,
                                height: 120,
                                color: Theme.of(context).primaryColor,
                              ),
                        DiscountPercentageBannerWidget(
                          regularPrice: state.products[index].regPrice,
                          salePrice: state.products[index].salePrice,
                          onLike: () {},
                        )
                      ],
                    ),
                  );
                },
                itemCount: state.products.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
              );
            }
            return Container();
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}


