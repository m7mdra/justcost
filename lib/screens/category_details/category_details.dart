import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/category/model/category.dart';
import 'package:justcost/data/user_sessions.dart';
import 'package:justcost/screens/category_products/category_products_screen.dart';
import 'package:justcost/screens/home/category/categores_bloc.dart';
import 'package:justcost/widget/category_widget.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';

import '../../dependencies_provider.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final Category category;
  final bool pickMode;

  const CategoryDetailsScreen(this.pickMode, {Key key, this.category})
      : super(key: key);

  @override
  _CategoryDetailsScreenState createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  CategoriesBloc _bloc;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = CategoriesBloc(DependenciesProvider.provide());
    _bloc.dispatch(FetchCategoriesDescendant(widget.category.id));
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Localizations.localeOf(context).languageCode == 'ar' ? widget.category.arName : widget.category.name,),
      ),
      body: BlocBuilder(
        bloc: _bloc,
        // ignore: missing_return
        builder: (BuildContext context, CategoriesState state) {
          if (state is CategoriesNetworkError) {
            return NetworkErrorWidget(
              onRetry: () {
                _bloc.dispatch(FetchCategoriesDescendant(widget.category.id));
              },
            );
          }
          if (state is CategoriesError) {
            return GeneralErrorWidget(onRetry: () {
              _bloc.dispatch(FetchCategoriesDescendant(widget.category.id));
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
          if (state is CategoriesLoadedState)
            return RefreshIndicator(
              key: _refreshIndicatorKey,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(Icons.keyboard_arrow_right),
                    title: Text(Localizations.localeOf(context).languageCode == 'ar' ? state.categories[index].arName : state.categories[index].name,),
                    onTap: () async {
                      var category = state.categories[index];
                      if (category.hasDescendants()) {
                        var cat =
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CategoryDetailsScreen(
                                      widget.pickMode,
                                      category: category,
                                    )));
                        Navigator.of(context).pop(cat);
                      } else {
                        if (widget.pickMode)
                          {
                            Navigator.of(context).pop(category);
                          }
                        else
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CategoryProductsScreen(category: category)));
                      }
                    },
                  );
                },
                itemCount: state.categories.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(height: 1,);
                },
              ),
              onRefresh: () {
                _bloc.dispatch(FetchCategoriesDescendant(widget.category.id));
                return null;
              },
            );
        },
      ),
    );
  }
}
