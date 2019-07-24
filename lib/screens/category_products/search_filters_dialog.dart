import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/attribute/model/category_attribute.dart';
import 'package:justcost/data/brand/model/brand.dart';
import 'package:justcost/screens/brand/brand_bloc.dart';
import 'package:justcost/util/tuple.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';
import '../../dependencies_provider.dart';
import 'attribute_filter_bloc.dart';
import 'package:justcost/i10n/app_localizations.dart';

class AttributeFilterDialog extends StatefulWidget {
  final int categoryId;

  const AttributeFilterDialog({Key key, this.categoryId}) : super(key: key);

  @override
  _AttributeFilterDialogState createState() => _AttributeFilterDialogState();
}

class _AttributeFilterDialogState extends State<AttributeFilterDialog> {
  FilterAttributeBloc _bloc;
  BrandBloc _brandBloc;
  Map<String, Attribute> selectedAttribute = Map<String, Attribute>();
  Map<String, Brand> selectedBrands = Map<String, Brand>();

  @override
  void initState() {
    super.initState();
    _brandBloc = BrandBloc(DependenciesProvider.provide())
      ..dispatch(LoadBrands(widget.categoryId));
    _bloc = FilterAttributeBloc(DependenciesProvider.provide());
    _bloc.dispatch(LoadAttributes(widget.categoryId));
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _brandBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Filters'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                var tuple = Tuple2<List<Brand>, List<Attribute>>(
                    selectedBrands.values.toList(),
                    selectedAttribute.values.toList());
                Navigator.pop(context, tuple);
              },
              icon: Icon(Icons.done),
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            BlocBuilder(
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
                      _brandBloc.dispatch(LoadBrands(widget.categoryId));
                    },
                  );
                if (state is AttributesErrorState)
                  return GeneralErrorWidget(
                    onRetry: () {
                      _bloc.dispatch(LoadAttributes(widget.categoryId));
                      _brandBloc.dispatch(LoadBrands(widget.categoryId));
                    },
                  );
                if (state is AttributesEmptyState) return Container();
                if (state is AttributesLoaded)
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(AppLocalizations.of(context).attributes),
                        dense: true,
                      ),
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(right: 16, left: 16),
                        itemCount: state.attributeGroupList.length,
                        itemBuilder: (BuildContext context, int parentIndex) {
                          return Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  state.attributeGroupList[parentIndex].group,
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                dense: true,
                              ),
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: state.attributeGroupList[parentIndex]
                                    .attributeList.length,
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
                                            state
                                                .attributeGroupList[parentIndex]
                                                .attributeList[index];
                                      } else
                                        selectedAttribute.remove(state
                                            .attributeGroupList[parentIndex]
                                            .attributeList[index]
                                            .name);
                                      setState(() {});
                                    },
                                    title: Text(state
                                        .attributeGroupList[parentIndex]
                                        .attributeList[index]
                                        .name),
                                  );
                                },
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  );
                return Container();
              },
            ),
            BlocBuilder(
              bloc: _brandBloc,
              builder: (BuildContext context, BrandState state) {
                if (state is BrandsLoaded)
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(AppLocalizations.of(context).selectBrand),
                        dense: true,
                      ),
                      ListView.separated(
                        padding: const EdgeInsets.only(right: 12, left: 12),
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            value: selectedBrands
                                .containsKey(state.brands[index].name),
                            dense: true,
                            title: Row(
                              children: <Widget>[
                                state.brands[index].img == null ||
                                        state.brands[index].img.isEmpty
                                    ? Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.red)
                                    : Image.network(state.brands[index].img,
                                        width: 50, height: 50),
                                Text(state.brands[index].name)
                              ],
                            ),
                            onChanged: (checked) {
                              if (checked)
                                selectedBrands[state.brands[index].name] =
                                    state.brands[index];
                              else
                                selectedBrands.remove(state.brands[index].name);
                              setState(() {});
                            },
                          );
                        },
                        primary: false,
                        shrinkWrap: true,
                        itemCount: state.brands.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            height: 4,
                          );
                        },
                      ),
                    ],
                  );
                return Container();
              },
            ),
          ],
        ));
  }
}
