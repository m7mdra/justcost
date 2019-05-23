import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/screens/city/city_bloc.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';

class CityPickerScreen extends StatefulWidget {
  @override
  _CityPickerScreenState createState() => _CityPickerScreenState();
}

class _CityPickerScreenState extends State<CityPickerScreen> {
  CitiesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CitiesBloc(DependenciesProvider.provide());
    _bloc.dispatch(LoadCities());
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
        title: Text('Select Place'),
      ),
      body: SafeArea(
          child: BlocBuilder(
            bloc: _bloc,
            builder: (BuildContext context, CitiesState state) {
              if (state is LoadingState)
                return Center(
                  child: CircularProgressIndicator(),
                );

              if (state is NetworkErrorState)
                return NetworkErrorWidget(
                  onRetry: () {
                    _bloc.dispatch(LoadCities());
                  },
                );
              if (state is NoDataState) return NoDataWidget();

              if (state is ErrorState) return GeneralErrorWidget();

              if (state is CitesLoaded)
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.cites[index].name),
                      onTap: () {
                        Navigator.pop(context, state.cites[index]);
                      },
                    );
                  },
                  itemCount: state.cites.length, separatorBuilder: (
                    BuildContext context, int index) {
                    return Divider(height: 1,);
                },
                );
            },
          )),
    );
  }
}
