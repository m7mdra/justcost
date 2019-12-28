import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/ad/ad_repository.dart';
import 'package:justcost/data/ad/model/my_ads_response.dart';
import 'package:justcost/data/user_sessions.dart';
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

  UserSession session = new UserSession();
  Future<String> language;
  String lanCode;

  var aboutShow = false;
  var ourMissionShow = false;
  var ourVisionShow = false;
  var whyShow = false;

  @override
  void initState() {
    super.initState();

    language = session.getCurrentLanguage();
    language.then((onValue){
      setState(() {
        lanCode = onValue;
      });
    });

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
                      onTap:(){
                        setState(() {
                          aboutShow ? aboutShow = false : aboutShow = true;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 100 * 90,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[800],width: 1),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        margin: EdgeInsets.all(4),
                        child: aboutShow
                            ? Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8,right: 8,top: 3),
                                      child: Text(lanCode == 'ar' ? state.response['about_us']  != null ? state.response['about_us'] : ' ' : state.response['en_about_us']  != null ? state.response['en_about_us'] : ' ',style: TextStyle(fontSize: 18),),
                                    ),
                                    IconButton(icon: Icon(Icons.arrow_drop_down,color: Colors.black,), onPressed: null),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10,left: 10),
                                  child: Divider(
                                    height: 1,
                                    thickness: 2,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  margin: EdgeInsets.all(4),
                                  child: Text(lanCode == 'ar' ? state.response['about_us']  != null ? state.response['about_us'] : ' ' : state.response['en_about_us']  != null ? state.response['en_about_us'] : ' ',style: TextStyle(fontSize: 18),),
                                )
                              ],
                            )
                            :Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8,top: 3),
                                  child: Text(lanCode == 'ar' ? state.response['about_us']  != null ? state.response['about_us'] : ' ' : state.response['en_about_us']  != null ? state.response['en_about_us'] : ' ',style: TextStyle(fontSize: 18),),
                              ),
                            IconButton(icon: Icon(Icons.arrow_right,color: Colors.black,), onPressed: null),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          ourMissionShow ? ourMissionShow = false : ourMissionShow = true;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 100 * 90,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[800],width: 1),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        margin: EdgeInsets.all(4),
                        child: ourMissionShow
                            ? Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8,right: 8,top: 3),
                                      child: Text(lanCode == 'ar' ? state.response['our_misson']  != null ? state.response['our_misson'] : ' ' : state.response['en_our_misson']  != null ? state.response['en_our_misson'] : ' ',style: TextStyle(fontSize: 18),),
                                    ),
                                    IconButton(icon: Icon(Icons.arrow_drop_down,color: Colors.black,), onPressed: null),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10,left: 10),
                                  child: Divider(
                                    height: 1,
                                    thickness: 2,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  margin: EdgeInsets.all(4),
                                  child: Text(lanCode == 'ar' ? state.response['our_misson']  != null ? state.response['our_misson'] : ' ' : state.response['en_our_misson']  != null ? state.response['en_our_misson'] : ' ',style: TextStyle(fontSize: 18),),
                                )

                              ],
                            )
                            :Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8,top: 3),
                                  child: Text(lanCode == 'ar' ? state.response['our_misson']  != null ? state.response['our_misson'] : ' ' : state.response['en_our_misson']  != null ? state.response['en_our_misson'] : ' ',style: TextStyle(fontSize: 18),),
                                ),
                                IconButton(icon: Icon(Icons.arrow_right,color: Colors.black,), onPressed: null),
                              ],
                            ),
                      ),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          ourVisionShow ? ourVisionShow = false : ourVisionShow = true;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 100 * 90,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[800],width: 1),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        margin: EdgeInsets.all(4),
                        child: ourVisionShow
                            ? Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8,top: 3),
                                  child: Text(lanCode == 'ar' ? state.response['our_vission']  != null ? state.response['our_vission'] : ' ' : state.response['en_our_vission']  != null ? state.response['en_our_vission'] : ' ',style: TextStyle(fontSize: 18),),
                                ),
                                IconButton(icon: Icon(Icons.arrow_drop_down,color: Colors.black,), onPressed: null),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Padding(
                              padding: const EdgeInsets.only(right: 10,left: 10),
                              child: Divider(
                                height: 1,
                                thickness: 2,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              margin: EdgeInsets.all(4),
                              child: Text(lanCode == 'ar' ? state.response['our_vission']  != null ? state.response['our_vission'] : ' ' : state.response['en_our_vission']  != null ? state.response['en_our_vission'] : ' ',style: TextStyle(fontSize: 18),),
                            )

                          ],
                        )
                            :Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8,top: 3),
                                  child: Text(lanCode == 'ar' ? state.response['our_vission']  != null ? state.response['our_vission'] : ' ' : state.response['en_our_vission']  != null ? state.response['en_our_vission'] : ' ',style: TextStyle(fontSize: 18),),
                                ),
                                IconButton(icon: Icon(Icons.arrow_right,color: Colors.black,), onPressed: null),
                              ],
                            ),
                      ),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          whyShow ? whyShow = false : whyShow = true;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 100 * 90,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[800],width: 1),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        margin: EdgeInsets.all(4),
                        child: whyShow
                            ? Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8,right: 8,top: 3),
                                      child: Text(lanCode == 'ar' ? state.response['why_us']  != null ? state.response['why_us'] : ' ' : state.response['en_why_us']  != null ? state.response['en_why_us'] : ' ',style: TextStyle(fontSize: 18),),
                                    ),
                                    IconButton(icon: Icon(Icons.arrow_drop_down,color: Colors.black,), onPressed: null),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10,left: 10),
                                  child: Divider(
                                    height: 1,
                                    thickness: 2,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  margin: EdgeInsets.all(4),
                                  child: Text(lanCode == 'ar' ? state.response['why_us']  != null ? state.response['why_us'] : ' ' : state.response['en_why_us']  != null ? state.response['en_why_us'] : ' ',style: TextStyle(fontSize: 18),),
                                )

                              ],
                            )
                            :Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8,top: 3),
                                  child: Text(lanCode == 'ar' ? state.response['why_us']  != null ? state.response['why_us'] : ' ' : state.response['en_why_us']  != null ? state.response['en_why_us'] : ' ',style: TextStyle(fontSize: 18),),
                                ),
                                IconButton(icon: Icon(Icons.arrow_right,color: Colors.black,), onPressed: null),
                              ],
                            ),
                          )
                    ),
                  ),

                  SizedBox(height: 20,),

                  Container(
                    height: 40,
                    margin: EdgeInsets.only(right: 28,left: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('تواصل معنا بواسطة : ',style: TextStyle(color: Colors.grey[900],fontSize: 18,fontWeight: FontWeight.w700),),
                      ],
                    ),
                  ),

                  SizedBox(height: 20,),

                  Container(
                    height: 40,
                    margin: EdgeInsets.only(right: 28,left: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('رقم الهاتف',style: TextStyle(color: Colors.grey[700],fontSize: 15,fontWeight: FontWeight.w600),),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(':',style: TextStyle(fontSize: 20),),
                        ),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(state.responseContact['phone'],style: TextStyle(color: Colors.grey[900],fontSize: 15,fontWeight: FontWeight.w600),),
                        )),
                      ],
                    ),
                  ),

                  Container(
                    height: 40,
                    margin: EdgeInsets.only(right: 28,left: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(' البريد الالكتروني',style: TextStyle(color: Colors.grey[700],fontSize: 15,fontWeight: FontWeight.w600),),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(':',style: TextStyle(fontSize: 20),),
                        ),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(state.responseContact['email'],style: TextStyle(color: Colors.grey[900],fontSize: 15,fontWeight: FontWeight.w600),),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    margin: EdgeInsets.only(right: 28,left: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('موقعنا',style: TextStyle(color: Colors.grey[700],fontSize: 15,fontWeight: FontWeight.w600),),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(':',style: TextStyle(fontSize: 20),),
                        ),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(state.responseContact['location'],style: TextStyle(color: Colors.grey[900],fontSize: 15,fontWeight: FontWeight.w600),),
                        )),
                      ],
                    ),
                  ),

                  SizedBox(height: 30,),

                  Container(
                    height: 40,
                    margin: EdgeInsets.only(right: 10,left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text(state.responseLinks[0]['link'],style: TextStyle(color: Colors.grey[700],fontSize: 11,fontWeight: FontWeight.w600),)),
                        Expanded(child: Text(state.responseLinks[1]['link'],style: TextStyle(color: Colors.grey[700],fontSize: 11,fontWeight: FontWeight.w600),)),
                        Expanded(child: Text(state.responseLinks[2]['link'],style: TextStyle(color: Colors.grey[700],fontSize: 11,fontWeight: FontWeight.w600),)),
                        Expanded(child: Text(state.responseLinks[3]['link'],style: TextStyle(color: Colors.grey[700],fontSize: 11,fontWeight: FontWeight.w600),)),
                        Expanded(child: Text(state.responseLinks[4]['link'],style: TextStyle(color: Colors.grey[700],fontSize: 11,fontWeight: FontWeight.w600),)),
                        Expanded(child: Text(state.responseLinks[5]['link'],style: TextStyle(color: Colors.grey[700],fontSize: 11,fontWeight: FontWeight.w600),)),

                      ],
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
