import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:justcost/error_delegate.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/ad_details/ad_details_screen.dart';
import 'package:justcost/screens/settings/setting_bloc.dart';
import 'package:justcost/screens/splash/AuthenticationBloc.dart';
import 'package:justcost/screens/splash/splash_screen.dart';
import 'package:justcost/screens/postad/post_ad_screen.dart';

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

GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  SettingBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = DependenciesProvider.provide();
    _bloc.dispatch(LoadCurrentLanguage());
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BlocSupervisor.delegate = GlobalAppBlocDelegate();
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, SettingState state) {
        if (state is LanguageChanged)
          return MaterialApp(
            navigatorKey: globalKey,
            title: 'JustCost',
            locale: Locale(state.languageCode),
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
                    fontFamily:
                        Localizations.localeOf(context).languageCode == 'ar'
                            ? 'Tajawal'
                            : 'OpenSans'),
                child: navigator,
              );
            },
            home: MultiBlocProvider(
              child: SplashScreen(),
              providers: <BlocProvider>[
                BlocProvider<AuthenticationBloc>(
                  builder: (context) => AuthenticationBloc(
                      session: getIt.get(), repository: getIt.get()),
                ),

              ],
            ),
          );
        return Container();
      },
    );
  }
}
