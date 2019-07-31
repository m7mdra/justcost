import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/category_details/category_details.dart';
import 'package:justcost/screens/home/category/categores_bloc.dart';
import 'package:justcost/util/tuple.dart';
import 'package:justcost/widget/category_widget.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';
import 'package:justcost/i10n/app_localizations.dart';
class CategoryPickerScreen extends StatefulWidget {
  @override
  _CategoryPickerScreenState createState() => _CategoryPickerScreenState();
}

class _CategoryPickerScreenState extends State<CategoryPickerScreen> {
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
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).selectCategory)),
      body: SafeArea(
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
            if (state is CategoriesLoadedState)
              return RefreshIndicator(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height * 0.65),
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return CategoryWidget(
                      category: state.categories[index],
                      onClick: (category) async {
                        if (category.hasDescendants()) {
                          var cat = await Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => CategoryDetailsScreen(
                                        true,
                                        category: category,
                                      )));

                          Navigator.of(context).pop(Tuple2(category, cat));
                        } else {
                          Navigator.of(context).pop(Tuple2(category, null));
                        }
                      },
                    );
                  },
                ),
                onRefresh: () {
                  _bloc.dispatch(FetchCategoriesEvent());
                },
              );
          },
        ),
      ),
    );
  }
}
