import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:justcost/error_delegate.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/ad_details/ad_details_screen.dart';
import 'package:justcost/screens/splash/AuthenticationBloc.dart';
import 'package:justcost/screens/splash/splash_screen.dart';
import 'package:justcost/post_ad_screen.dart';

import 'dependencies_provider.dart';
import 'package:bloc/bloc.dart';

void main() {
  DependenciesProvider.build();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  GlobalKey<NavigatorState> globalKey=GlobalKey<NavigatorState>();
  Future onSelectNotification(String payload) async {
    print(payload);

    globalKey.currentState.push(MaterialPageRoute(builder: (context) => AdDetailsScreen()));

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    BlocSupervisor.delegate = GlobalAppBlocDelegate();

    return MaterialApp(
      navigatorKey: globalKey,
      title: 'JustCost',
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('ar', ''),
        const Locale('en', ''),
      ],
      debugShowCheckedModeBanner: false,
      builder: (context, navigator) {
        return Theme(
          data: ThemeData(
              backgroundColor: Colors.white,
              primaryColor: Color(0xff3B3F4E),
              primaryColorLight: Color(0xff666a7a),
              accentColor: Color(0xffF9D413),
              buttonColor: Color(0xffF9D413),
              primaryColorDark: Color(0xff141926),
              fontFamily: Localizations.localeOf(context).languageCode == 'ar'
                  ? 'Tajawal'
                  : 'OpenSans'),
          child: navigator,
        );
      },
      home: BlocProvider.value(
        child: SplashScreen(),
        value:
            AuthenticationBloc(session: getIt.get(), repository: getIt.get()),
      ),
    );
  }
}
