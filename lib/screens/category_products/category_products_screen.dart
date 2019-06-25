import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/category/model/category.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/category_products/attribute_filter_bloc.dart';
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
  TextEditingController _controller;
  List<int> selectAttribute = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    _bloc = CategoryProductsBloc(DependenciesProvider.provide())
      ..dispatch(LoadDataEvent(widget.category.id,selectAttribute, _controller.text));
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              List<int> list = await showDialog(
                context: context,
                builder: (context) => AttributeFilterDialog(
                      categoryId: widget.category.id,
                    ),
              );
              if (list != null) {
                setState(() {
                  selectAttribute = list;
                });
                _bloc.dispatch(LoadDataEvent(widget.category.id,selectAttribute, _controller.text));

              }
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
                _bloc.dispatch(LoadDataEvent(widget.category.id,selectAttribute, _controller.text));
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
                    _bloc.dispatch(LoadDataEvent(widget.category.id,selectAttribute, _controller.text));
                  },
                );
              if (state is NetworkErrorState)
                return NetworkErrorWidget(
                  onRetry: () {
                    _bloc.dispatch(LoadDataEvent(widget.category.id,selectAttribute, _controller.text));
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

class AttributeFilterDialog extends StatefulWidget {
  final int categoryId;

  const AttributeFilterDialog({Key key, this.categoryId}) : super(key: key);

  @override
  _AttributeFilterDialogState createState() => _AttributeFilterDialogState();
}

class _AttributeFilterDialogState extends State<AttributeFilterDialog> {
  FilterAttributeBloc _bloc;
  Map<String, int> selectedAttribute = Map<String, int>();

  @override
  void initState() {
    super.initState();
    _bloc = FilterAttributeBloc(DependenciesProvider.provide());
    _bloc.dispatch(LoadAttributes(widget.categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (selectedAttribute.isEmpty)
                Navigator.pop(context);
              else
                Navigator.pop(context, selectedAttribute.values.toList());
            },
            icon: Icon(Icons.done),
          )
        ],
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, AttributeFilterState state) {
          if (state is AttributesLoadingState)
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
          if (state is AttributesNetworkErrorState)
            return NetworkErrorWidget(
              onRetry: () {
                _bloc.dispatch(LoadAttributes(widget.categoryId));
              },
            );
          if (state is AttributesErrorState)
            return GeneralErrorWidget(
              onRetry: () {
                _bloc.dispatch(LoadAttributes(widget.categoryId));
              },
            );
          if (state is AttributesEmptyState) return NoDataWidget();
          if (state is AttributesLoaded)
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.attributeGroupList.length,
              itemBuilder: (BuildContext context, int parentIndex) {
                return Column(
                  children: <Widget>[
                    ListTile(
                        title:
                            Text(state.attributeGroupList[parentIndex].group)),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state
                          .attributeGroupList[parentIndex].attributeList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CheckboxListTile(
                          dense: true,
                          value: selectedAttribute.containsKey(state
                              .attributeGroupList[parentIndex]
                              .attributeList[index]
                              .name),
                          onChanged: (change) {
                            if (change) {
                              selectedAttribute[state
                                      .attributeGroupList[parentIndex]
                                      .attributeList[index]
                                      .name] =
                                  state.attributeGroupList[parentIndex]
                                      .attributeList[index].id;
                            } else
                              selectedAttribute.remove(state
                                  .attributeGroupList[parentIndex]
                                  .attributeList[index]
                                  .name);
                            setState(() {});
                          },
                          title: Text(state.attributeGroupList[parentIndex]
                              .attributeList[index].name),
                        );
                      },
                    )
                  ],
                );
              },
            );
          return Container();
        },
      ),
    );
  }
}
