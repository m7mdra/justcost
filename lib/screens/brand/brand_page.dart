import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/brand/model/brand.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/brand/brand_bloc.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';
import 'package:justcost/i10n/app_localizations.dart';
class BrandPage extends StatefulWidget {
  final int categoryId;

  const BrandPage({Key key, this.categoryId}) : super(key: key);

  @override
  _BrandPageState createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  BrandBloc _bloc;

  Brand defaultBrand = new Brand();

  @override
  void initState() {
    super.initState();
    _bloc = BrandBloc(DependenciesProvider.provide());
    _bloc.add(LoadBrands(widget.categoryId));
  }

  @override
  void close() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    defaultBrand.name = "Not Clissiefied";
    defaultBrand.id   = 9;
    defaultBrand.img  = "";
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).selectBrand),
      ),
      body: BlocBuilder(
        builder: (BuildContext context, BrandState state) {
          if (state is BrandsLoading)
            // ignore: missing_return
            return Center(
              child: CircularProgressIndicator(),
            );
          if (state is BrandsEmpty) return Column(
            children: <Widget>[

              SizedBox(height: 20,),
              BrandWidget(
                  brand: defaultBrand,
                onTap: (defaultBrand) {
                  Navigator.of(context).pop(defaultBrand);
                  print(defaultBrand.id);
                },
              )
            ],
          );
          if (state is BrandsError)
            return GeneralErrorWidget(
              onRetry: () {
                _bloc.add(LoadBrands(widget.categoryId));
              },
            );
          if (state is BrandsNetworkError)
            return NetworkErrorWidget(
              onRetry: () {
                _bloc.add(LoadBrands(widget.categoryId));
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
          if(state is BrandsEmpty)
            return NoDataWidget();

          return Container();
        },
        bloc: _bloc,
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
    return Container(
      margin: EdgeInsets.only(left: 20,right: 15),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color:Colors.black26,width: 1),
      ),
      child: ListTile(
        dense: true,
        leading: brand.img == null || brand.img.isEmpty
            ? Container(width: 50, height: 50,decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),)
            : Image.network(brand.img,width: 50,height: 50,fit: BoxFit.contain,),
        title: Container(
          //0900100000
          margin: EdgeInsets.only(top: 5),
            child: Text(brand.name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
        onTap: () => onTap(brand),
      ),
    );
  }
}
