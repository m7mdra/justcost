import 'package:flutter/material.dart';
import 'package:justcost/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
        accentColor: Colors.yellowAccent,
      ),
      home: SplashScreen(),
    );
  }
}

