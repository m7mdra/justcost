import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/attribute/model/category_attribute.dart';
import 'package:justcost/data/brand/model/brand.dart';
import 'package:justcost/data/category/model/category.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/data/user_sessions.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/ad_details/ad_details_screen.dart';
import 'package:justcost/screens/category_products/category_products_bloc.dart';
import 'package:justcost/screens/category_products/search_filters_dialog.dart';
import 'package:justcost/util/tuple.dart';
import 'package:justcost/widget/ad_widget.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';
import 'package:justcost/i10n/app_localizations.dart';

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
  ScrollController _scrollController;
  List<Product> filteredProducts = [];


  UserSession session = new UserSession();
  Future<String> language;
  String lanCode;

  @override
  void initState() {
    super.initState();

    language = session.getCurrentLanguage();
    language.then((onValue){
      setState(() {
        lanCode = onValue;
      });
    });

    _controller = TextEditingController();
    categoryProductBloc = CategoryProductsBloc(DependenciesProvider.provide())
      ..dispatch(loadDataEvent);
    _scrollController = ScrollController(keepScrollOffset: true);
    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        categoryProductBloc.dispatch(LoadNextPage(
//            widget.category.name,
//            selectedAttribute.map((attribute) => attribute.id).toList(),
//            selectedBrands.map((brand) => brand.id).toList(),
//            _controller.text));
//      }
    });
  }

  get loadDataEvent => LoadDataEvent(
      widget.category.id,
      selectedAttribute.map((attribute) => attribute.id).toList(),
      _controller.text,
      selectedBrands.map((brand) => brand.id).toList(),
      products: filteredProducts
  );

  get filterDataEvent => FilteredDataEvent(
      widget.category.id,
      selectedAttribute.map((attribute) => attribute.id).toList(),
      _controller.text,
      selectedBrands.map((brand) => brand.id).toList(),
      products: filteredProducts
  );

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
                print('Not Null');
                setState(() {
                  selectedAttribute = list.item2;
                  selectedBrands = list.item1;
                  chipData.clear();
                  chipData.addAll(selectedBrands);
                  chipData.addAll(selectedAttribute);
                });
                if(selectedAttribute.length > 0 || selectedBrands.length > 0){
                  categoryProductBloc.dispatch(filterDataEvent);
                }
                //categoryProductBloc.dispatch(loadDataEvent);
              }
              else{
                print('Null');
              }
            },
            icon: Icon(Icons.filter_list),
          )
        ],
        title: Text(lanCode == 'ar' ? widget.category.arName : widget.category.name,),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: TextField(
              onChanged: (value) {
                if(value.length > 2){
                  categoryProductBloc.dispatch(loadDataEvent);
                }
                if(value.length == 0){
                  categoryProductBloc.dispatch(loadDataEvent);
                }
              },
              controller: _controller,
              decoration:
                  InputDecoration.collapsed(hintText: AppLocalizations.of(context).search).copyWith(
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
              if (state is EmptyState)
                return NoDataWidget();
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
                {
                  filteredProducts = state.products;
                  return Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemBuilder: (BuildContext context, int index) {
                          if (index >= state.products.length)
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          else
                            return AdWidget(
                              key: ValueKey(state.products[index].productId),
                              product: state.products[index],
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AdDetailsScreen(
                                          product: state.products[index],
                                        )));
                              },
                            );
                        },
                        itemCount: state.hasReachedMax
                            ? state.products.length
                            : state.products.length + 1,
                      ));
                }
              if (state is FilteredCategoryProductsLoaded)
                return Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        if (index >= state.filterProducts.length)
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        else
                          return AdWidget(
                            key: ValueKey(state.filterProducts[index].productId),
                            product: state.filterProducts [index],
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AdDetailsScreen(
                                        product: state.filterProducts[index],
                                      )));
                            },
                          );
                      },
                      itemCount: state.hasReachedMax
                          ? state.filterProducts.length
                          : state.filterProducts.length + 1,
                    ));
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
