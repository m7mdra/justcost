import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/attribute/model/attribute.dart';
import 'package:justcost/data/brand/model/brand.dart';
import 'package:justcost/data/city/model/city.dart';
import 'package:justcost/data/city/model/country.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/ad_details/ad_details_screen.dart';
import 'package:justcost/screens/category_products/search_filters_dialog.dart';
import 'package:justcost/screens/city/city_picker_screen.dart';
import 'package:justcost/screens/search/search_bloc.dart';
import 'package:justcost/util/tuple.dart';
import 'package:justcost/widget/ad_widget.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';
import 'package:justcost/widget/sliver_app_bar_header.dart';
import 'package:justcost/i10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  final String keyword;

  const SearchScreen([this.keyword = '']);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchBloc _bloc;
  TextEditingController _searchTextEditingController;
  City city;
  int sortType;
  String sortName;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc(DependenciesProvider.provide());
    if (widget.keyword.isNotEmpty)
      _bloc.add(SearchProductByName(widget.keyword, -1));
    _searchTextEditingController = TextEditingController();
    _scrollController = ScrollController(keepScrollOffset: true);
//    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        _bloc.add(LoadNextPage(
//            _searchTextEditingController.value.text.toString(),
//            city != null ? city.id : -1));
//      }
//    });
  }

  @override
  void close() {
    super.dispose();
    _bloc.close();
    _searchTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          margin: EdgeInsets.only(left: 40),
          child: Card(
            child: TextField(
              controller: _searchTextEditingController,
              onChanged: (value) {
                if (value.isNotEmpty)
                  _bloc.add(
                      SearchProductByName(value, city != null ? city.id : -1));
              },
              decoration: InputDecoration.collapsed(
                      hintText: AppLocalizations.of(context).search)
                  .copyWith(
                contentPadding: const EdgeInsets.all(10),
                icon: Icon(Icons.search),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          Visibility(
            visible: false,
            child: IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () async {
                Tuple2<List<Brand>, List<Attribute>> list = await showDialog(
                  context: context,
                  builder: (context) => AttributeFilterDialog(
                  ),
                );
                if (list != null) {
                  print('Not Null LENGTH $list');
//                setState(() {
//                  selectedAttribute = list.item2;
//                  selectedBrands = list.item1;
//                  chipData.clear();
//                  chipData.addAll(selectedBrands);
//                  chipData.addAll(selectedAttribute);
//                });
//                if(selectedAttribute.length > 0 || selectedBrands.length > 0){
//                  categoryProductBloc.add(filterDataEvent);
//                }
                  //categoryProductBloc.add(loadDataEvent);
                }
                else{
                  print('Null');
                }
              },
            ),
          )
        ],
      ),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarHeaderDelegate(
                      maxHeight: 60,
                      minHeight: 60,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              buildCityDropDown(),
                              buildVerticalDivider(),
                              buildSort(),
                            ],
                          ),
                        ),
                      )))
            ];
          },
          body: BlocBuilder(
            bloc: _bloc,
            // ignore: missing_return
            builder: (BuildContext context, SearchState state) {
              if (state is SearchLoading)
                return Center(
                  child: CircularProgressIndicator(),
                );
              if (state is SearchError)
                return Center(
                  child: GeneralErrorWidget(
                    onRetry: () {
                      retrySearch();
                    },
                  ),
                );
              if (state is SearchNoResult) return NoDataWidget();
              if (state is SearchNetworkError)
                return NetworkErrorWidget(
                  onRetry: () {
                    retrySearch();
                  },
                );
              if (state is SearchIdle) return Container();
              if (state is SearchFound)
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
                                builder: (BuildContext context) =>
                                    AdDetailsScreen(
                                      product: state.products[index],
                                    )));
                          },
                        );
                    },
                    itemCount: state.hasReachedMax
                        ? state.products.length
                        : state.products.length + 1);
            },
          )),
    );
  }

  void retrySearch() => _bloc.add(SearchProductByName(
      _searchTextEditingController.text.trim(), city != null ? city.id : -1));

  Widget buildSort() {
    return InkWell(
      onTap: () async {
        var sortType = await showDialog(
            context: context,
            builder: (context) {
              return RoundedAlertDialog(
                title: Text(AppLocalizations.of(context).sortSearchResult),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.sort_by_alpha),
                      title: Text(AppLocalizations.of(context).sortByNameASC),
                      onTap: () {
                        Navigator.of(context).pop(1);
                      },
                    ),
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.sort_by_alpha),
                      title: Text(AppLocalizations.of(context).sortByNameDESC),
                      onTap: () {
                        Navigator.of(context).pop(2);
                      },
                    ),
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.attach_money),
                      title: Text(AppLocalizations.of(context).sortByPriceASC),
                      onTap: () {
                        Navigator.of(context).pop(3);
                      },
                    ),
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.attach_money),
                      title: Text(AppLocalizations.of(context).sortByPriceDESC),
                      onTap: () {
                        Navigator.of(context).pop(4);
                      },
                    ),
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.attach_money),
                      title:
                          Text(AppLocalizations.of(context).sortByDiscountASC),
                      onTap: () {
                        Navigator.of(context).pop(5);
                      },
                    ),
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.attach_money),
                      title:
                          Text(AppLocalizations.of(context).sortByDiscountDESC),
                      onTap: () {
                        Navigator.of(context).pop(6);
                      },
                    ),
                  ],
                ),
              );
            });
        _handleSortType(sortType);
      },
      splashColor: Theme.of(context).accentColor,
      child: Row(
        children: <Widget>[
          Icon(Icons.sort),
          SizedBox(
            width: 2,
          ),
          Text(sortType != null ? sortName : AppLocalizations.of(context).sort),
        ],
      ),
    );
  }


  Widget buildVerticalDivider() {
    return VerticalDivider();
  }

  Widget buildCityDropDown() {
    return InkWell(
      onTap: () async {
        City city = await showDialog(
            context: context,
            builder: (context) {
              return CityPickerScreen();
            });
        setState(() {
          this.city = city;
        });
        _bloc.add(SearchProductByName(
            _searchTextEditingController.text.trim(),
            city != null ? city.id : -1));
      },
      child: Row(
        children: <Widget>[
          Icon(Icons.place),
          Text(city != null ? city.name : AppLocalizations.of(context).filterByCity),
        ],
      ),
    );
  }

  _handleSortType(int sortType) {
    setState(() {
      this.sortType = sortType;

      switch (sortType) {
        case 1:
          sortName = AppLocalizations.of(context).name;
          _bloc.add(SortByNameAscending());
          break;
        case 2:
          sortName = AppLocalizations.of(context).name;
          _bloc.add(SortByNameDescending());
          break;
        case 3:
          sortName = AppLocalizations.of(context).price;
          _bloc.add(SortByPriceAscending());
          break;
        case 4:
          sortName = AppLocalizations.of(context).price;
          _bloc.add(SortByPriceDescending());
          break;
        case 5:
          sortName = AppLocalizations.of(context).discount;
          _bloc.add(SortByDiscountAscending());
          break;
        case 6:
          sortName = AppLocalizations.of(context).discount;
          _bloc.add(SortByDiscountDescending());
          break;
      }
    });
  }
}
