import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:justcost/screens/ad_details/ad_details_screen.dart';
import 'package:justcost/screens/home/main_screen.dart';
import 'package:justcost/screens/intro/intro_screen.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/screens/splash/AuthenticationBloc.dart';
import 'package:justcost/screens/verification/account_verification_screen.dart';
import 'package:justcost/i10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthenticationBloc _authenticationBloc;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: BlocBuilder(
        bloc: _authenticationBloc,
        builder: (BuildContext context, AuthenticationState state) {
          if (state is AuthenticationFailed) {
            return SplashFailedWidget(
              onPressed: () {
                _authenticationBloc.dispatch(AppStarted());
              },
            );
          }
          return SplashLoadingWidget();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _authenticationBloc = BlocProvider.of(context);
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
      if (state is FirstTimeLaunch)
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => IntroScreen()));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _authenticationBloc.dispose();
  }
}

class SplashLoadingWidget extends StatelessWidget {
  const SplashLoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}

class SplashFailedWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const SplashFailedWidget({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
            child: Column(
              children: <Widget>[
                Text(AppLocalizations.of(context).failedToLoadData),
                RaisedButton(
                  onPressed: onPressed,
                  child: Text(AppLocalizations.of(context).retryButton),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
