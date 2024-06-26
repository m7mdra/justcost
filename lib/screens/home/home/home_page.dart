import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:justcost/data/category/model/category.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/data/user_sessions.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/ad_details/ad_details_screen.dart';
import 'package:justcost/screens/category_details/category_details.dart';
import 'package:justcost/screens/featured_ads/featured_ads_screen.dart';
import 'package:justcost/screens/home/category/categores_bloc.dart';
import 'package:justcost/screens/home/home/featured_ads_bloc.dart';
import 'package:justcost/screens/home/home/recent_ads_bloc.dart';
import 'package:justcost/screens/home/home/slider_bloc.dart';
import 'package:justcost/screens/recentads/recent_ad_screen.dart';
import 'package:justcost/widget/ad_widget.dart';
import 'package:justcost/widget/discount_badge_widget.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

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
  FeaturedAdsBloc _featuredAdsBloc;
  var isLoading = false;
  var loadNextLoading = false;
  ScrollController _scrollController;
  List<Product> recentProducts;

  loadData() {

  }

  @override
  void initState() {
    super.initState();

    _bloc = SliderBloc(DependenciesProvider.provide());
    _categoriesBloc = CategoriesBloc(DependenciesProvider.provide());
    _featuredAdsBloc = FeaturedAdsBloc(DependenciesProvider.provide());
    _recentAdsBloc = RecentAdsBloc(DependenciesProvider.provide());
    fetchData();

    _scrollController = ScrollController(keepScrollOffset: true);
    _scrollController.addListener(() async {
      if(!loadNextLoading){
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          print('reached 221');
          setState(() {
            print('eeeee');
            loadNextLoading = true;
          });
          await Future.delayed(Duration(seconds: 2));
          _recentAdsBloc.add(LoadRecentNextPage());

          setState(() {
            print('iiii');
            loadNextLoading = false;
          });
        }
      }
    });
  }
  void fetchData() {
    _bloc.add(LoadSlider());
    _categoriesBloc.add(FetchCategoriesEvent());
    _featuredAdsBloc.add(LoadFeaturedAds());
    _recentAdsBloc.add(LoadRecentAds());
  }
  @override
  void dispose() {
    super.dispose();
    _bloc.close();
    _categoriesBloc.close();
    _recentAdsBloc.close();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      child: ListView(
        controller: _scrollController,
        children: <Widget>[
          Container(
            key: UniqueKey(),
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: BlocBuilder(
              bloc: _bloc,
              builder: (BuildContext context, SliderState state) {
                if (state is SliderLoaded) {
                  return state.sliders.isEmpty
                      ? Image.asset('assets/icon/android/logo-500.png')
                      : Swiper(
                          controller: SwiperController(),
                          autoplay: true,
                          autoplayDisableOnInteraction: true,
                          pagination: SwiperPagination(),
                          viewportFraction: 0.9,
                          indicatorLayout: PageIndicatorLayout.SCALE,
                          curve: Curves.fastOutSlowIn,
                          itemCount: state.sliders.length,
                          duration: 500,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Image.network(
                                state.sliders[index] != null
                                    ? state.sliders[index]
                                    : 'http://185.151.29.205:8099/images/logo.png',
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                }
                if (state is SliderError) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(AppLocalizations.of(context).failedToLoadData),
                      OutlineButton(
                        onPressed: () {
                          fetchData();
                        },
                        child: Text(AppLocalizations.of(context).retryButton),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context).featuredCategories,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      height: 140,
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CategoryDetailsScreen(
                                        false,
                                        category: state.categories[index],
                                      )));
                            },
                            child: FeatureCategoryWidget(
                              category: state.categories[index],
                              lanCode:
                                  Localizations.localeOf(context).languageCode,
                            ),
                          );
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
          BlocBuilder(
            bloc: _featuredAdsBloc,
            builder: (BuildContext context, FeaturedAdsState state) {
              if (state is FeaturedAdsLoaded) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).featuredAds,
                              style: TextStyle(fontSize: 18),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FeaturedAdsScreen()));
                              },
                              child: Text(
                                  AppLocalizations.of(context).seeMoreButton),
                              textTheme: ButtonTextTheme.accent,
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ),
                    ),
                    Container(
                      height: 220,
                      child: ListView.builder(
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return FeaturedAdsWidget(
                            product: state.products[index],
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AdDetailsScreen(
                                        product: state.products[index],
                                      )));
                            },
                          );
                        },
                        itemCount: state.products.length,
                        shrinkWrap: true,
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
          BlocBuilder(
            bloc: _recentAdsBloc,
            builder: (BuildContext context, RecentAdsState state) {
              if (state is RecentAdsLoaded) {
                recentProducts = state.products;
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).recentAds,
                              style: TextStyle(fontSize: 18),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RecentAdsScreen()));
                              },
                              child: Text(
                                  AppLocalizations.of(context).seeMoreButton),
                              textTheme: ButtonTextTheme.accent,
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    AdDetailsScreen(
                                      product: state.products[index],
                                    )));
                          },
                        );
                      },
                      itemCount: state.products.length,
                      shrinkWrap: true,
                    ),
                    Visibility(
                      visible: loadNextLoading ? true : false,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10,),
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }
              return Container();
            },
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
      onRefresh: () async {
        fetchData();
        await new Future.delayed(const Duration(seconds: 1));

        return null;
      },
    );
  }

  Future _loadData() async {
    // perform fetching data delay
    await new Future.delayed(new Duration(seconds: 2));

    print("load more");
    // update data and loading status
    setState(() {
      isLoading = false;
    });
  }


  @override
  bool get wantKeepAlive => true;
}



class FeatureCategoryWidget extends StatelessWidget {
  final Category category;
  final String lanCode;

  const FeatureCategoryWidget({Key key, this.category, this.lanCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 140,
      child: Card(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          category.image == null || category.image.isEmpty
              ? Container(
                  height: 70,
                  width: 70,
                )
              : Image.network(
                  category.image,
                  height: 70,
                  width: 70,
                ),
          Text(
            Localizations.localeOf(context).languageCode == 'ar'
                ? category.arName
                : category.name,
            maxLines: 1,
            textAlign: TextAlign.center,
          )
        ],
      )),
    );
  }
}

class FeaturedAdsWidget extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const FeaturedAdsWidget({Key key, this.product, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/loading.jpg',
                      image: product.media.length != 0
                          ? product.media[0].url
                          : 'http://185.151.29.205:8099/images/logo.png',
                      height: 120,
                      width: 150,
                    )),
                DiscountPercentageBannerWidget(
                  regularPrice: product.regPrice,
                  salePrice: product.salePrice,
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              width: 150,
              child: Text(
                product.title,
                style: TextStyle(fontSize: 16),
                maxLines: 2,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${product.salePrice} AED',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Colors.red),
                  ),
                  /*Container(
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(8)),
                  ),*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
