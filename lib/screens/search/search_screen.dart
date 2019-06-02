import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/city/model/city.dart';
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

  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc(DependenciesProvider.provide());
    if (widget.keyword.isNotEmpty)
      _bloc.dispatch(SearchProductByName(widget.keyword));
    _searchTextEditingController = TextEditingController();
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
              if (value.isNotEmpty) _bloc.dispatch(SearchProductByName(value));
            },
            decoration: InputDecoration.collapsed(hintText: 'Search').copyWith(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              buildCityDropDown(),
                              buildVerticalDivider(),
                              buildFilter(),
                              buildVerticalDivider(),
                              buildChangeView(),
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
                  itemBuilder: (context, index) {
                    return AdWidget(
                      product: state.products[index],
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => AdDetailsScreen(
                                  product: state.products[index],
                                )));
                      },
                    );
                  },
                  itemCount: state.products.length,
                );
            },
          )),
    );
  }

  void retrySearch() => _bloc
      .dispatch(SearchProductByName(_searchTextEditingController.text.trim()));

  Widget buildSort() {
    return InkWell(
      onTap: () async {
        var sortType = await showDialog(
            context: context,
            builder: (context) {
              return RoundedAlertDialog(
                title: Text('Sort Search Result'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.sort_by_alpha),
                      title: Text('Name - Ascending'),
                      onTap: () {
                        Navigator.of(context).pop(1);
                      },
                    ),
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.sort_by_alpha),
                      title: Text('Name - Descending'),
                      onTap: () {
                        Navigator.of(context).pop(2);
                      },
                    ),
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.attach_money),
                      title: Text('Price - Ascending'),
                      onTap: () {
                        Navigator.of(context).pop(3);
                      },
                    ),
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.attach_money),
                      title: Text('Price - Descending'),
                      onTap: () {
                        Navigator.of(context).pop(4);
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
          Text(sortType != null ? sortName : 'Sort'),
        ],
      ),
    );
  }

  Row buildChangeView() {
    return Row(
      children: <Widget>[
        Icon(Icons.grid_on),
        SizedBox(
          width: 2,
        ),
        Text('View'),
      ],
    );
  }

  Widget buildFilter() {
    return InkWell(
      onTap: () {},
      splashColor: Theme.of(context).accentColor,
      child: Row(
        children: <Widget>[
          Icon(Icons.filter_list),
          SizedBox(
            width: 2,
          ),
          Text('Filter'),
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
        if (city != null)
          setState(() {
            this.city = city;
          });
        print(this.city);
      },
      child: Row(
        children: <Widget>[
          Icon(Icons.place),
          Text(city != null ? city.name : 'Filter by City'),
        ],
      ),
    );
  }

  _handleSortType(int sortType) {
    setState(() {
      this.sortType = sortType;

      switch (sortType) {
        case 1:
          sortName = 'Name';
          _bloc.dispatch(SortByNameAscending());
          break;
        case 2:
          sortName = 'Name';
          _bloc.dispatch(SortByNameDescending());
          break;
        case 3:
          sortName = 'Price';
          _bloc.dispatch(SortByPriceAscending());
          break;
        case 4:
          sortName = 'Price';
          _bloc.dispatch(SortByPriceDescending());
          break;
        case 5:
          sortName = 'Rate';
          _bloc.dispatch(SortByRateAscending());
          break;
        case 6:
          sortName = 'Rate';
          _bloc.dispatch(SortByRateDescending());

          break;
      }
    });
  }
}
