import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/ad/ad_repository.dart';
import 'package:justcost/data/ad/model/my_ads_response.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/about_us/about_us_bloc.dart';
import 'package:justcost/screens/myad_details/my_ad_details_screen.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';


class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  AboutBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AboutBloc(DependenciesProvider.provide());
    _bloc.dispatch(LoadAboutData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).aboutUs),
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, GetAboutDataState state) {
          if (state is LoadingState || state is IdleState)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (state is NetworkErrorState)
            return Center(
              child: NetworkErrorWidget(onRetry: () {
                _bloc.dispatch(LoadAboutData());
              }),
            );
          if (state is ErrorState)
            return Center(
              child: GeneralErrorWidget(
                onRetry: () {
                  _bloc.dispatch(LoadAboutData());
                },
              ),
            );
          if (state is AboutDataLoadedState) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20,),
                  Center(
                    child: GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 100 * 90,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[800],width: 1),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        margin: EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.add,color: Colors.black,), onPressed: null),
                            Padding(
                              padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
                              child: Text(state.response['about_us']  != null ? state.response['about_us'] : 'terms',style: TextStyle(fontSize: 18),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0,),
                  Center(
                    child: GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 100 * 90,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[800],width: 1),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        margin: EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.add,color: Colors.black,), onPressed: null),
                            Padding(
                              padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
                              child: Text(state.response['our_misson']  != null ? state.response['our_misson'] : 'terms',style: TextStyle(fontSize: 18),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0,),
                  Center(
                    child: GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 100 * 90,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[800],width: 1),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        margin: EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.add,color: Colors.black,), onPressed: null),
                            Padding(
                              padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
                              child: Text(state.response['our_vission']  != null ? state.response['our_vission'] : 'terms',style: TextStyle(fontSize: 18),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0,),
                  Center(
                    child: GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 100 * 90,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[800],width: 1),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        margin: EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.add,color: Colors.black,), onPressed: null),
                            Padding(
                              padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
                              child: Text(state.response['why_us']  != null ? state.response['why_us'] : 'terms',style: TextStyle(fontSize: 18),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Text _getStatusFromCode(BuildContext context, int status) {
    if (status == 1)
      return Text(
        AppLocalizations.of(context).adPendingStatus,
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      );
    else if (status == 2)
      return Text(
        AppLocalizations.of(context).adRejectedStatus,
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
    else
      return Text(
        AppLocalizations.of(context).adApprovedStatus,
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      );
  }
}
