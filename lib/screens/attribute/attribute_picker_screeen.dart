import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/attribute/attribute_repository.dart';
import 'package:justcost/data/attribute/model/category_attribute.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/category_products/attribute_filter_bloc.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';
import 'package:justcost/i10n/app_localizations.dart';
class AttributePickerScreen extends StatefulWidget {
  final int categoryId;
  final List<Attribute> attributes;

  const AttributePickerScreen({Key key, this.categoryId, this.attributes})
      : super(key: key);

  @override
  _AttributePickerScreenState createState() => _AttributePickerScreenState();
}

class _AttributePickerScreenState extends State<AttributePickerScreen> {
  FilterAttributeBloc _bloc;
  Map<int, Attribute> selectedAttribute = Map<int, Attribute>();

  @override
  void initState() {
    super.initState();
    widget.attributes.forEach((attr) => selectedAttribute[attr.id] = attr);

    _bloc = FilterAttributeBloc(
        DependenciesProvider.provide<AttributeRepository>());
    _bloc.dispatch(LoadAttributes(widget.categoryId));
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).attributes),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done_all),
            onPressed: () {
              Navigator.pop(context, selectedAttribute.values.toList());
            },
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
          if (state is AttributesLoaded) {
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
                              .id),
                          onChanged: (change) {
                            print(change);
                            var id = state.attributeGroupList[parentIndex]
                                .attributeList[index].id;
                            var attribute = state
                                .attributeGroupList[parentIndex]
                                .attributeList[index];
                            print("$id\t${attribute.toJson()}");
                            if (change) {
                              selectedAttribute[id] = attribute;
                            } else {
                              selectedAttribute.remove(id);
                            }
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
          }
          return Container();
        },
      ),
    );
  }
}
