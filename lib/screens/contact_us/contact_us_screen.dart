import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/user_sessions.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';

import 'contact_us_bloc.dart';


class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  ContactUsBloc _bloc;

  TextEditingController name , email , subject , message ;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex;

  @override
  void initState() {
    super.initState();

    name = TextEditingController();
    email = TextEditingController();
    subject = TextEditingController();
    message = TextEditingController();
    
    _bloc = ContactUsBloc(DependenciesProvider.provide());
    regex = new RegExp(pattern);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).contactUs),
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, ContactUsState state) {
          if (state is LoadingState)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (state is NetworkErrorState)
            return Center(
              child: NetworkErrorWidget(onRetry: () {
                _bloc.add(SendReport());
              }),
            );
          if (state is ErrorState)
            return Center(
              child: GeneralErrorWidget(
                onRetry: () {
                  _bloc.add(SendReport());
                },
              ),
            );
          if (state is SendReportSuccess)
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20,),
                Center(child: Icon(Icons.check,size: 40,)),
                SizedBox(height: 15,),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(left: 40,right: 40),
                    child: Text(
                      AppLocalizations.of(context).thanksContact,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(left: 40,right: 40),
                    child: Text(
                      AppLocalizations.of(context).thanksMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                        height: 40,
                        width: 110,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Center(child: Text(AppLocalizations.of(context).ok,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w800),),)
                    ),
                  ),
                )
              ],
            );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 100 * 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 40,right: 40),
                  child: Text(
                    AppLocalizations.of(context).contactUsTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 40,right: 40),
                  height: 40,
                  child: TextField(
                    controller: name,
                    maxLengthEnforced: true,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      labelText: AppLocalizations.of(context).fullNameField,
                      labelStyle: TextStyle(fontSize: 13),


                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 40,right: 40),
                  height: 40,
                  child: TextField(
                    controller: email,
                    maxLengthEnforced: true,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      labelText: AppLocalizations.of(context).emailFieldLabel,
                      labelStyle: TextStyle(fontSize: 13),

                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 40,right: 40),
                  height: 40,
                  child: TextField(
                    controller: subject,
                    maxLengthEnforced: true,
                    autofocus: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        labelText: AppLocalizations.of(context).contactTitle,
                      labelStyle: TextStyle(fontSize: 13),

                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 40,right: 40),
                  height: 100,
                  child: TextField(
                    controller: message,
                    maxLengthEnforced: true,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      labelText: AppLocalizations.of(context).contactMessage,

                    ),
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    if(name.text.trim().length < 1){
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text(AppLocalizations.of(context).nameValidationEmptyError),
                      ));
                      return;
                    }
                    else if(email.text.trim().length < 1){
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text(AppLocalizations.of(context).emailFieldEmptyError),
                      ));
                      return;
                    }
                    else if(!regex.hasMatch(email.text)){
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text(AppLocalizations.of(context).emailFieldInvalidError),
                      ));
                      return;
                    }
                    else if(subject.text.trim().length < 1){
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text(AppLocalizations.of(context).titleEmptyError),
                      ));
                      return;
                    }
                    else if(message.text.trim().length < 1){
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text(AppLocalizations.of(context).detailsEmptyError),
                      ));
                      return;
                    }
                    _bloc.add(SendReport(
                      name: name.text,
                      email: email.text,
                      subject: subject.text,
                      message: message.text
                    ));
                  },
                  child: Container(
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(child: Text(AppLocalizations.of(context).submitButton,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w800),),)
                  ),
                )
              ],
            ),
          );
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
