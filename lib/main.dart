import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/home/main_screen.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/screens/splash/AuthenticationBloc.dart';
import 'package:justcost/screens/splash/splash_screen.dart';
import 'dependencies_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  DependenciesProvider.build();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JustCost',
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('ar', ''),
      ],
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
        bloc: AuthenticationBloc(session: getIt.get(), repository: getIt.get()),
      ),
    );
  }
}
