import 'package:flutter/material.dart';
import 'package:justcost/screens/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
          child: Card(
        child: Image.asset(
          'assets/icon/android/logo-500.png',
          width: 150,
          height: 150,
        ),
      )),
    );
  }

  @override
  void initState() {
    super.initState();
     Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }
}
