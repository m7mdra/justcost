import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/screens/ad_details/ad_details_screen.dart';
import 'package:justcost/widget/ad_widget.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';
import 'liked_products_bloc.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/dependencies_provider.dart';

class LikedProductsScreen extends StatefulWidget {
  @override
  _LikedProductsScreenState createState() => _LikedProductsScreenState();
}

class _LikedProductsScreenState extends State<LikedProductsScreen> {
  LikedProductBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LikedProductBloc(DependenciesProvider.provide());
    _bloc.add(LoadMyLikes());
  }

  @override
  void close() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).favoriteAds),
      ),
      body: BlocBuilder(
        bloc: _bloc,

        // ignore: missing_return
        builder: (BuildContext context, LikedState state) {
          if (state is LoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is MyLikesLoaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return AdWidget(
                  product: state.products[index],
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdDetailsScreen(
                                  product: state.products[index],
                                )));
                  },
                );
              },
              itemCount: state.products.length,
            );
          }
          if (state is NetworkErrorState) {
            return Center(
              child: NetworkErrorWidget(
                onRetry: () {
                  _bloc.add(LoadMyLikes());
                },
              ),
            );
          }
          if (state is ErrorState) {
            return Center(
              child: GeneralErrorWidget(
                onRetry: () {
                  _bloc.add(LoadMyLikes());
                },
              ),
            );
          }
          if (state is EmptyState) {
            return Center(
              child: NoDataWidget(),
            );
          }
        },
      ),
    );
  }
}
