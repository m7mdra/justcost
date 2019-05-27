import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/brand/model/brand.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/brand/brand_bloc.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';

class BrandPage extends StatefulWidget {
  final int categoryId;

  const BrandPage({Key key, this.categoryId}) : super(key: key);

  @override
  _BrandPageState createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  BrandBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BrandBloc(DependenciesProvider.provide());
    _bloc.dispatch(LoadBrands(widget.categoryId));
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
        title: Text('Select brand'),
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, BrandState state) {
          if (state is BrandsLoading)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (state is BrandsEmpty) return NoDataWidget();
          if (state is BrandsError)
            return GeneralErrorWidget(
              onRetry: () {
                _bloc.dispatch(LoadBrands(widget.categoryId));
              },
            );
          if (state is BrandsNetworkError)
            return NetworkErrorWidget(
              onRetry: () {
                _bloc.dispatch(LoadBrands(widget.categoryId));
              },
            );
          if (state is BrandsLoaded)
            return ListView.separated(
              itemBuilder: (context, index) {
                return BrandWidget(
                  brand: state.brands[index],
                  onTap: (brand) {
                    Navigator.of(context).pop(brand);
                  },
                );
              },
              itemCount: state.brands.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 4,
                );
              },
            );
        },
      ),
    );
  }
}

class BrandWidget extends StatelessWidget {
  final Brand brand;
  final ValueChanged<Brand> onTap;

  const BrandWidget({Key key, this.brand, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: brand.img == null || brand.img.isEmpty
          ? Container(width: 50, height: 50, color: Colors.red)
          : Image.network(brand.img),
      title: Text(brand.name),
      onTap: () => onTap(brand),
    );
  }
}
