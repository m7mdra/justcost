import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/screens/data/user_sessions.dart';
import 'package:justcost/screens/splash/AuthenticationBloc.dart';
import 'package:justcost/screens/splash/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          backgroundColor: Colors.white,
          primaryColor: Color(0xff3B3F4E),
          primaryColorLight: Color(0xff666a7a),
          accentColor: Color(0xffF9D413),
          buttonColor: Color(0xffF9D413),
          fontFamily: 'OpenSans',
          primaryColorDark: Color(0xff141926)),
      home: BlocProvider(
        child: SplashScreen(),
        bloc: AuthenticationBloc(session: UserSession()),
      ),
    );
  }
}
