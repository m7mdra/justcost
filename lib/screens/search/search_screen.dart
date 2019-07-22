import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/city/model/city.dart';
import 'package:justcost/data/city/model/country.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/ad_details/ad_details_screen.dart';
import 'package:justcost/screens/city/city_picker_screen.dart';
import 'package:justcost/screens/search/search_bloc.dart';
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
      _bloc.dispatch(SearchProductByName(widget.keyword, -1));
    _searchTextEditingController = TextEditingController();
    _scrollController = ScrollController(keepScrollOffset: true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _bloc.dispatch(LoadNextPage(
            _searchTextEditingController.value.text.toString(),
            city != null ? city.id : -1));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _searchTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Card(
          child: TextField(
            controller: _searchTextEditingController,
            onChanged: (value) {
              if (value.isNotEmpty)
                _bloc.dispatch(
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
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

  void retrySearch() => _bloc.dispatch(SearchProductByName(
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
        _bloc.dispatch(SearchProductByName(
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
          _bloc.dispatch(SortByNameAscending());
          break;
        case 2:
          sortName = AppLocalizations.of(context).name;
          _bloc.dispatch(SortByNameDescending());
          break;
        case 3:
          sortName = AppLocalizations.of(context).price;
          _bloc.dispatch(SortByPriceAscending());
          break;
        case 4:
          sortName = AppLocalizations.of(context).price;
          _bloc.dispatch(SortByPriceDescending());
          break;
        case 5:
          sortName = AppLocalizations.of(context).discount;
          _bloc.dispatch(SortByDiscountAscending());
          break;
        case 6:
          sortName = AppLocalizations.of(context).discount;
          _bloc.dispatch(SortByDiscountDescending());
          break;
      }
    });
  }
}
