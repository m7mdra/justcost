import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/screens/verification/account_verification_screen.dart';
import 'package:justcost/screens/home/main_screen.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/screens/splash/AuthenticationBloc.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthenticationBloc _authenticationBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Card(
              child: Image.asset(
                'assets/icon/android/logo-500.png',
                width: 150,
                height: 150,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: LinearProgressIndicator(),
                width: 150,
                height: 2,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _authenticationBloc.dispatch(AppStarted());
    _authenticationBloc.state.listen((state) {
      if (state is UserAuthenticated)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      if (state is UserUnauthenticated)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      if (state is AccountNotVerified)
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AccountVerificationScreen()));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _authenticationBloc.dispose();
  }
}
