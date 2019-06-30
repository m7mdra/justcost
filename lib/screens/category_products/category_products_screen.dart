import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/category/model/category.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/category_products/category_products_bloc.dart';
import 'package:justcost/screens/category_products/search_filters_dialog.dart';
import 'package:justcost/util/tuple.dart';
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
  CategoryProductsBloc categoryProductBloc;

  TextEditingController _controller;
  List<int> selectedAttribute = [];
  List<int> selectedBrands = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    categoryProductBloc = CategoryProductsBloc(DependenciesProvider.provide())
      ..dispatch(LoadDataEvent(widget.category.id, selectedAttribute,
          _controller.text, selectedBrands));
  }

  @override
  void dispose() {
    super.dispose();
    categoryProductBloc.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              Tuple2<List<int>, List<int>> list = await showDialog(
                context: context,
                builder: (context) => AttributeFilterDialog(
                      categoryId: widget.category.id,
                    ),
              );

              setState(() {
                selectedAttribute = list.item2;
                selectedBrands = list.item1;
              });
              categoryProductBloc.dispatch(LoadDataEvent(widget.category.id,
                  selectedAttribute, _controller.text, selectedBrands));
            },
            icon: Icon(Icons.filter_list),
          )
        ],
        title: Text(widget.category.name),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: TextField(
              onChanged: (value) {
                categoryProductBloc.dispatch(LoadDataEvent(widget.category.id,
                    selectedAttribute, _controller.text, selectedBrands));
              },
              controller: _controller,
              decoration:
                  InputDecoration.collapsed(hintText: 'Search').copyWith(
                contentPadding: const EdgeInsets.all(10),
                icon: Icon(Icons.search),
              ),
            ),
          ),
          BlocBuilder(
            bloc: categoryProductBloc,
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
                    categoryProductBloc.dispatch(LoadDataEvent(
                        widget.category.id,
                        selectedAttribute,
                        _controller.text,
                        selectedBrands));
                  },
                );
              if (state is NetworkErrorState)
                return NetworkErrorWidget(
                  onRetry: () {
                    categoryProductBloc.dispatch(LoadDataEvent(
                        widget.category.id,
                        selectedAttribute,
                        _controller.text,
                        selectedBrands));
                  },
                );
              if (state is CategoryProductsLoaded)
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AdWidget(
                        onTap: () {},
                        product: state.products[index],
                      );
                    },
                  ),
                );
            },
          ),
        ],
      ),
    );
  }
}
