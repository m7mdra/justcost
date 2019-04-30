import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/category/model/category.dart';
import 'package:justcost/screens/home/category/categores_bloc.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../dependencies_provider.dart';

class CategoriesPage extends StatefulWidget {
  final Key key;

  CategoriesPage({this.key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with AutomaticKeepAliveClientMixin<CategoriesPage> {
  CategoriesBloc _bloc;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = CategoriesBloc(DependenciesProvider.provide());
    _bloc.dispatch(FetchCategoriesEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, CategoriesState state) {
        if (state is CategoriesError) {
          return NetworkErrorWidget(
            onRetry: () {
              _bloc.dispatch(FetchCategoriesEvent());
            },
          );
        }
        if (state is CategoriesLoadingState)
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        if (state is NoCategorieState) return NoDataWidget();
        if (state is CategoriesLoadedState) return Container();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CategoryWidget extends StatelessWidget {
  final Category category;

  const CategoryWidget({Key key, this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          category.image == null || category.image.isEmpty
              ? Container(
                  width: 200,
                  height: 135,
                  color: Colors.red,
                )
              : CachedNetworkImage(
                  imageUrl: category.image,
                  width: 200,
                  height: 135,
                  placeholder: (context, url) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  },
                ),
          const SizedBox(
            height: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.body1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
