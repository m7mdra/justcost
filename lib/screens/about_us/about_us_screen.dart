import 'package:flutter/cupertino.dart';
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
import 'package:url_launcher/url_launcher.dart';


class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  AboutBloc _bloc;



  var aboutShow = false;
  var ourMissionShow = false;
  var ourVisionShow = false;
  var whyShow = false;

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
                                      child: Text(AppLocalizations.of(context).aboutUs,style: TextStyle(fontSize: 18),),
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
                                  child: Text(Localizations.localeOf(context).languageCode == 'ar' ? state.response['about_us']  != null ? state.response['about_us'] : ' ' : state.response['en_about_us']  != null ? state.response['en_about_us'] : ' ',style: TextStyle(fontSize: 18),),
                                )
                              ],
                            )
                            :Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8,top: 3),
                                  child: Text(AppLocalizations.of(context).aboutUs,style: TextStyle(fontSize: 18),),
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
                                      child: Text(AppLocalizations.of(context).ourMission,style: TextStyle(fontSize: 18),),
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
                                  child: Text(Localizations.localeOf(context).languageCode == 'ar' ? state.response['our_misson']  != null ? state.response['our_misson'] : ' ' : state.response['en_our_misson']  != null ? state.response['en_our_misson'] : ' ',style: TextStyle(fontSize: 18),),
                                )

                              ],
                            )
                            :Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8,top: 3),
                                  child: Text(AppLocalizations.of(context).ourMission,style: TextStyle(fontSize: 18),),
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
                                  child: Text(AppLocalizations.of(context).ourVision,style: TextStyle(fontSize: 18),),
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
                              child: Text(Localizations.localeOf(context).languageCode == 'ar' ? state.response['our_vission']  != null ? state.response['our_vission'] : ' ' : state.response['en_our_vission']  != null ? state.response['en_our_vission'] : ' ',style: TextStyle(fontSize: 18),),
                            )

                          ],
                        )
                            :Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8,top: 3),
                                  child: Text(AppLocalizations.of(context).ourVision,style: TextStyle(fontSize: 18),),
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
                                      child: Text(AppLocalizations.of(context).whyUs,style: TextStyle(fontSize: 18),),
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
                                  child: Text(Localizations.localeOf(context).languageCode == 'ar' ? state.response['why_us']  != null ? state.response['why_us'] : ' ' : state.response['en_why_us']  != null ? state.response['en_why_us'] : ' ',style: TextStyle(fontSize: 18),),
                                )

                              ],
                            )
                            :Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8,top: 3),
                                  child: Text(AppLocalizations.of(context).whyUs,style: TextStyle(fontSize: 18),),
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
                        Text(AppLocalizations.of(context).contactUsVia+'  :',style: TextStyle(color: Colors.grey[900],fontSize: 18,fontWeight: FontWeight.w700),),
                      ],
                    ),
                  ),

                  SizedBox(height: 10,),

                  Container(
                    margin: EdgeInsets.only(right: 28,left: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.phone_android,size: 15,color: Colors.grey[800],),
                              SizedBox(width: 5,),
                              Text(AppLocalizations.of(context).phoneNumberField,style: TextStyle(color: Colors.grey[700],fontSize: 15,fontWeight: FontWeight.w800),),
                            ],
                          ),
                        ),
                        Container(width:5,child: Text(':',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),)),
                        Expanded(
                          flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(state.responseContact['phone'],style: TextStyle(letterSpacing: 1,color: Colors.black87,fontSize: 15,fontWeight: FontWeight.w800),textAlign: TextAlign.center),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.only(right: 28,left: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.email,size: 15,color: Colors.grey[800],),
                                SizedBox(width: 5,),
                                Text(AppLocalizations.of(context).emailFieldLabel,style: TextStyle(color: Colors.grey[700],fontSize: 13,fontWeight: FontWeight.w800),),
                              ],
                            )),
                        Container(width:5,child: Text(':',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),)),
                        Expanded(
                          flex: 3,
                            child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(state.responseContact['email'],style: TextStyle(letterSpacing: 1,color: Colors.black87,fontSize: 15,fontWeight: FontWeight.w800),textAlign: TextAlign.center,),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.only(right: 28,left: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.location_on,size: 15,color: Colors.grey[800],),
                                SizedBox(width: 5,),
                                Text(AppLocalizations.of(context).location,style: TextStyle(color: Colors.grey[700],fontSize: 15,fontWeight: FontWeight.w800),),
                              ],
                            )),
                        Container(width:5,child: Text(':',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),)),
                        Expanded(
                          flex: 3,
                            child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(state.responseContact['location'],style: TextStyle(letterSpacing: 1,color: Colors.black87,fontSize: 15,fontWeight: FontWeight.w800),textAlign: TextAlign.center),
                        )),
                      ],
                    ),
                  ),

                  SizedBox(height: 20,),

                  Container(
                    height: 70,
                    margin: EdgeInsets.only(right: 10,left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            _launchURL(state.responseLinks[1]['link']);
                          },
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Image.asset('assets/images/twitter.png',width: 50,height: 50,),
//                                Text(state.responseLinks[1]['link'],style: TextStyle(color: Colors.grey[700],fontSize: 11,fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: (){
                            _launchURL(state.responseLinks[2]['link']);
                          },
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Image.asset('assets/images/instagram.png',width: 50,height: 50,),
//                                Text(state.responseLinks[2]['link'],style: TextStyle(color: Colors.grey[700],fontSize: 11,fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: (){
                            _launchURL(state.responseLinks[0]['link']);
                          },
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Image.asset('assets/images/facebook.png',width: 50,height: 50,),
//                                Text(state.responseLinks[0]['link'],style: TextStyle(color: Colors.grey[700],fontSize: 11,fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ),
                        ),

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
