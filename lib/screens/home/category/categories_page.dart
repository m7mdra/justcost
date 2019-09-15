import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/screens/category_details/category_details.dart';
import 'package:justcost/screens/category_products/category_products_screen.dart';
import 'package:justcost/screens/home/category/categores_bloc.dart';
import 'package:justcost/widget/category_widget.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';

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
  void initState() {
    super.initState();
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
    super.build(context);
    return RefreshIndicator(
      onRefresh: () {
        _bloc.dispatch(FetchCategoriesEvent());
        return Future.value();
      },
      child: BlocBuilder(
        bloc: _bloc,
        // ignore: missing_return
        builder: (BuildContext context, CategoriesState state) {
          if (state is CategoriesNetworkError) {
            return NetworkErrorWidget(
              onRetry: () {
                _bloc.dispatch(FetchCategoriesEvent());
              },
            );
          }
          if (state is CategoriesError) {
            return GeneralErrorWidget(onRetry: () {
              _bloc.dispatch(FetchCategoriesEvent());
            });
          }
          if (state is CategoriesLoadingState)
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
          if (state is NoCategorieState) return NoDataWidget();
          if (state is CategoriesLoadedState) {
            var size = MediaQuery.of(context).size;

            return RefreshIndicator(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return CategoryWidget(
                    category: state.categories[index],
                    onClick: (category) {
                      if (category.hasDescendants())
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CategoryDetailsScreen(
                                  false,
                                  category: category,
                                )));
                      else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CategoryProductsScreen(category: category)));
                      }
                    },
                  );
                },
              ),
              onRefresh: () {
                _bloc.dispatch(FetchCategoriesEvent());
              },
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
