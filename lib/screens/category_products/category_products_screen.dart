import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/attribute/model/category_attribute.dart';
import 'package:justcost/data/brand/model/brand.dart';
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
  List<Attribute> selectedAttribute = [];
  List<Brand> selectedBrands = [];
  List chipData = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    categoryProductBloc = CategoryProductsBloc(DependenciesProvider.provide())
      ..dispatch(loadDataEvent);
  }

  get loadDataEvent => LoadDataEvent(
      widget.category.id,
      selectedAttribute.map((attribute) => attribute.id).toList(),
      _controller.text,
      selectedBrands.map((brand) => brand.id).toList());

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
              Tuple2<List<Brand>, List<Attribute>> list = await showDialog(
                context: context,
                builder: (context) => AttributeFilterDialog(
                  categoryId: widget.category.id,
                ),
              );
              if (list != null) {
                setState(() {
                  selectedAttribute = list.item2;
                  selectedBrands = list.item1;
                  chipData.clear();
                  chipData.addAll(selectedBrands);
                  chipData.addAll(selectedAttribute);
                });
                categoryProductBloc.dispatch(loadDataEvent);
              }
            },
            icon: Icon(Icons.filter_list),
          )
        ],
        title: Text(widget.category.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              child: TextField(
                onChanged: (value) {
                  categoryProductBloc.dispatch(loadDataEvent);
                },
                controller: _controller,
                decoration:
                    InputDecoration.collapsed(hintText: 'Search').copyWith(
                  contentPadding: const EdgeInsets.all(10),
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            Wrap(
              children: chipData.map((item) {
                if (item is Brand)
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Chip(
                      label: Text(item.name),
                      avatar: Image.network(item.img),
                      onDeleted: () {
                        chipData.remove(item);
                        selectedBrands.remove(item);
                        setState(() {});
                        categoryProductBloc.dispatch(loadDataEvent);
                      },
                    ),
                  );
                if (item is Attribute)
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Chip(
                      padding: const EdgeInsets.all(4),
                      label: Text(item.name),
                      onDeleted: () {
                        chipData.remove(item);
                        selectedAttribute.remove(item);
                        setState(() {});
                        categoryProductBloc.dispatch(loadDataEvent);
                      },
                    ),
                  );
                return Container();
              }).toList(),
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
                  return Center(
                    child: GeneralErrorWidget(
                      onRetry: () {
                        categoryProductBloc.dispatch(loadDataEvent);
                      },
                    ),
                  );
                if (state is NetworkErrorState)
                  return Center(
                    child: NetworkErrorWidget(
                      onRetry: () {
                        categoryProductBloc.dispatch(loadDataEvent);
                      },
                    ),
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
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
