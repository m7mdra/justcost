import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/search/search_bloc.dart';
import 'package:justcost/widget/ad_widget.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';
import 'package:justcost/widget/sliver_app_bar_header.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchBloc _bloc;
  TextEditingController _searchTextEditingController;

  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc(DependenciesProvider.provide());
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
              _bloc.dispatch(SearchProductByName(value));
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
                    onRetry: () => retrySearch,
                  ),
                );
              if (state is SearchNoResult) return NoDataWidget();
              if (state is SearchNetworkError)
                return NetworkErrorWidget(
                  onRetry: () => retrySearch,
                );
              if(state is SearchIdle)
                return Container();
              if (state is SearchFound)
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return AdWidget(
                      product: state.products[index],
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

  Row buildSort() {
    return Row(
      children: <Widget>[
        Icon(Icons.sort_by_alpha),
        SizedBox(
          width: 2,
        ),
        Text('sort'),
      ],
    );
  }

  Row buildChangeView() {
    return Row(
      children: <Widget>[
        Icon(Icons.list),
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

  Container buildVerticalDivider() {
    return Container(
      height: 60,
      width: 1,
      color: Colors.grey,
    );
  }

  Widget buildCityDropDown() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: <Widget>[
          Icon(Icons.place),
          Text('City name'),
          Icon(Icons.arrow_drop_down)
        ],
      ),
    );
  }
}
