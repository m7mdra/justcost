import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/category/model/category.dart' as prefix0;
import 'package:justcost/data/category/model/category.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/ad_details/AdDetailsScreen.dart';
import 'package:justcost/screens/home/category/categores_bloc.dart';
import 'package:justcost/screens/home/home/recent_ads_bloc.dart';
import 'package:justcost/screens/home/home/slider_bloc.dart';
import 'package:justcost/widget/ad_widget.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/icon_text.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<ScrollNotification> onScroll;

  const HomePage({Key key, this.onScroll}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  SliderBloc _bloc;
  CategoriesBloc _categoriesBloc;
  RecentAdsBloc _recentAdsBloc;
  SwiperController _controller;

  @override
  void initState() {
    super.initState();
    _controller=SwiperController();
    _bloc = SliderBloc(DependenciesProvider.provide());
    _categoriesBloc = CategoriesBloc(DependenciesProvider.provide());
    _recentAdsBloc = RecentAdsBloc(DependenciesProvider.provide());
    _bloc.dispatch(LoadSlider());
    _categoriesBloc.dispatch(FetchCategoriesEvent());
    _recentAdsBloc.dispatch(LoadRecentAds());
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _categoriesBloc.dispose();
    _recentAdsBloc.dispose();
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          key: UniqueKey(),
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: BlocBuilder(
            bloc: _bloc,
            builder: (BuildContext context, SliderState state) {
              print(state);
              /*if (state is SliderLoaded) {
                return Swiper(
                  controller: SwiperController(),
                  autoplay: true,
                  pagination: SwiperPagination(),
                  viewportFraction: 0.9,
                  indicatorLayout: PageIndicatorLayout.SCALE,
                  curve: Curves.fastOutSlowIn,
                  itemCount: 3,
                  duration: 500,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Image.network(
                        state.sliders[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }*/
              if (state is SliderError) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Failed to load Data'),
                    OutlineButton(
                      onPressed: () {
                        _bloc.dispatch(LoadSlider());
                      },
                      child: Text('Retry'),
                    )
                  ],
                );
              }

              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
                strokeWidth: 1,
              ));
            },
          ),
        ),
        BlocBuilder(
          bloc: _categoriesBloc,
          builder: (BuildContext context, CategoriesState state) {
            if (state is CategoriesLoadedState)
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Featured Categories',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Container(
                    height: 120,
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return FeatureCategoryWidget(
                            category: state.categories[index]);
                      },
                      itemCount: state.categories.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ],
              );
            return Container();
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Featured Ads',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          constraints: BoxConstraints.tight(
              Size(MediaQuery.of(context).size.width, 225)),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return FeaturedAdsWidget();
            },
            itemCount: 10,
            scrollDirection: Axis.horizontal,
          ),
        ),
        BlocBuilder(
          bloc: _recentAdsBloc,
          builder: (BuildContext context, RecentAdsState state) {
            if (state is RecentAdsLoaded) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment:Alignment.centerLeft,
                      child: Text(
                        'Recent Ads',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  ListView.builder(
                    primary: false,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return AdWidget(
                        product: state.products[index],
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AdDetailsScreen()));
                        },
                      );
                    },
                    itemCount: state.products.length,
                    shrinkWrap: true,
                  ),
                ],
              );
            }
            return Container();
          },
        ),
        Icon(
          Icons.more_horiz,
          color: Colors.grey,
        ),
        const SizedBox(
          height: 100,
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FeatureCategoryWidget extends StatelessWidget {
  final Category category;

  const FeatureCategoryWidget({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      child: Card(
          child: GridTile(
        child: category.image == null || category.image.isEmpty
            ? Container(
                height: 70,
                width: 70,
              )
            : Image.network(category.image),
        footer: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            category.name,
            textAlign: TextAlign.center,
          )),
        ),
      )),
    );
  }
}

class FeaturedAdsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Container(
                width: 150,
                height: 140,
                color: Colors.red,
              ),
              Container(
                color: Colors.yellowAccent,
                child: Text('10% OFF'),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Text('Ad name'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('100 AED'),
                IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () {},
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
