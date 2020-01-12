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

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthenticationBloc _authenticationBloc;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
                _authenticationBloc.add(AppStarted());
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
    initNotificationAndListen();
    _authenticationBloc = BlocProvider.of(context);
    _authenticationBloc.add(AppStarted());
    _authenticationBloc.forEach((state){
      if (state is UserAuthenticated || state is UserUnauthenticated)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
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
  void close() {
    super.dispose();
    _authenticationBloc.close();
  }

  Future onSelectNotification(String payload) async {
    print(payload);

    globalKey.currentState
        .push(MaterialPageRoute(builder: (context) => AdDetailsScreen()));
  }

  void initNotificationAndListen() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentSound: true,
        defaultPresentAlert: true);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'jcGenNoti',
        'JustCost general Notification Channel',
        'general Notification Channel',
        importance: Importance.Default,
        priority: Priority.Default,
        playSound: true);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));

    firebaseMessaging.setAutoInitEnabled(true);
    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
        return Future.value(false);
      },
      onMessage: (Map<String, dynamic> message) {
        print(message.toString());
        flutterLocalNotificationsPlugin.show(
          Random().nextInt(100),
          message['notification']['title'] ?? '',
          message['notification']['body'],
          platformChannelSpecifics,
          payload: message['data']['Product_id'],
        );
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
        return Future.value(false);
      },
    );
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
              width: 200,
              height: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: LinearProgressIndicator(),
              width: 200,
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
