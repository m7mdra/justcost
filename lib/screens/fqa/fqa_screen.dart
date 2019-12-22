import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/user_sessions.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/fqa/fqa_bloc.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';

import '../../dependencies_provider.dart';

class FQAScreen extends StatefulWidget {
  @override
  _FQAScreenState createState() => _FQAScreenState();
}

class _FQAScreenState extends State<FQAScreen> {
  FQABloc _bloc;
  var show= false;

  UserSession session = new UserSession();
  Future<String> language;
  String lanCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    language = session.getCurrentLanguage();
    language.then((onValue){
      setState(() {
        lanCode = onValue;
      });
    });

    _bloc = FQABloc(DependenciesProvider.provide());
    _bloc.dispatch(LoadFQAData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).fqa),
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, GetFQADataState state) {
          if (state is LoadingState || state is IdleState)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (state is NetworkErrorState)
            return Center(
              child: NetworkErrorWidget(onRetry: () {
                _bloc.dispatch(LoadFQAData());
              }),
            );
          if (state is ErrorState)
            return Center(
              child: GeneralErrorWidget(
                onRetry: () {
                  _bloc.dispatch(LoadFQAData());
                },
              ),
            );
          if (state is FQADataLoadedState) {
            var questions = state.fqaList;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return Center(
                        child: GestureDetector(
                          onTap:(){
                            setState(() {
                               if(!questions[index].show){
                                 show = true;
                                 questions[index].show = true;
                               }
                               else{
                                 show = false;
                                 questions[index].show = false;
                               }
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 100 * 90,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[800],width: 1),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            margin: EdgeInsets.all(4),
                            child: questions[index].show
                                ? Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8,right: 8,top: 3),
                                      child: Text(lanCode == 'ar' ? questions[index].questionAr  != null ? questions[index].questionAr : ' ' : questions[index].question  != null ? questions[index].question : ' ',style: TextStyle(fontSize: 18),),
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
                                  child: Text(lanCode == 'ar' ? questions[index].answerAr  != null ? questions[index].answerAr : ' ' : questions[index].answer  != null ? questions[index].answer : ' ',style: TextStyle(fontSize: 18),),
                                )
                              ],
                            )
                                :Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8,top: 3),
                                  child: Text(lanCode == 'ar' ? questions[index].questionAr  != null ? questions[index].questionAr : ' ' : questions[index].question  != null ? questions[index].question : ' ',style: TextStyle(fontSize: 18),),
                                ),
                                IconButton(icon: Icon(Icons.arrow_right,color: Colors.black,), onPressed: null),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: questions.length,
                  )
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
