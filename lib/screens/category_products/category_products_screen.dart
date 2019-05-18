import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:justcost/data/category/model/category.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/category_products/category_products_bloc.dart';
import 'package:justcost/widget/ad_widget.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';

class CategoryProductsScreen extends StatefulWidget {
  final Category category;

  const CategoryProductsScreen({Key key, this.category}) : super(key: key);
  @override
  _CategoryProductsScreenState createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  CategoryProductsBloc _bloc;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = CategoryProductsBloc(DependenciesProvider.provide())
      ..dispatch(LoadDataEvent(widget.category.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, CategoryProductsState state) {
          print(state);
          if (state is LoadingState)
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
          if (state is EmptyState) return NoDataWidget();
          if (state is ErrorState)
            return GeneralErrorWidget(
              onRetry: () {
                _bloc.dispatch(LoadDataEvent(widget.category.id));
              },
            );
          if (state is NetworkErrorState)
            return NetworkErrorWidget(
              onRetry: () {
                _bloc.dispatch(LoadDataEvent(widget.category.id));
              },
            );
          if (state is CategoryProductsLoaded)
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (BuildContext context, int index) {
                return AdWidget(
                  onTap: () {},
                  product: state.products[index],
                );
              },
            );
        },
      ),
    );
  }
}
