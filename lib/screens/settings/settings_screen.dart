import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/screens/home/home/home_page.dart';
import 'package:justcost/screens/home/main_screen.dart';
import 'package:justcost/screens/settings/notification_bloc.dart' as prefix0;
import 'package:justcost/screens/settings/notification_bloc.dart';
import 'package:justcost/screens/settings/setting_bloc.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';

class SettingsScreen extends StatefulWidget {
  var token;
  SettingsScreen({this.token});
  @override
  _SettingsScreenState createState() => _SettingsScreenState(this.token);
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingBloc _bloc;
  NotificationBloc _notificationBloc;
  bool isSwitched = true;

  var token;
  _SettingsScreenState(this.token);

  @override
  Future initState() {
    super.initState();
    _bloc = DependenciesProvider.provide();
    _notificationBloc = NotificationBloc(DependenciesProvider.provide());
    _bloc.add(LoadCurrentLanguage());
     _notificationBloc.add(LoadNotificationState(token: token));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: ListView(
        children: <Widget>[
          BlocBuilder(
            bloc: _bloc,
            builder: (BuildContext context, SettingState state) {
              if (state is LanguageChanged)
                return ListTile(
                  dense: true,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => RoundedAlertDialog(
                              title: Text(
                                  AppLocalizations.of(context).changeLanguage),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                        AppLocalizations.of(context).arabic),
                                    onTap: () {
                                      _bloc.add(ChangeLanguage('ar'));
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainScreen()));
                                    },
                                    dense: true,
                                    selected: state.languageCode == "ar",
                                  ),
                                  ListTile(
                                    title: Text(
                                        AppLocalizations.of(context).english),
                                    onTap: () {
                                      _bloc.add(ChangeLanguage('en'));
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainScreen()));
                                    },
                                    dense: true,
                                    selected: state.languageCode == "en",
                                  ),
                                ],
                              ),
                            ));
                  },
                  title: Text(
                    AppLocalizations.of(context).changeLanguage,
                  ),
                  leading: Icon(Icons.language),
                  subtitle: Text(state.languageCode == "ar"
                      ? AppLocalizations.of(context).arabic
                      : AppLocalizations.of(context).english),
                );
              return ListTile(
                title: Text(
                  AppLocalizations.of(context).changeLanguage,
                ),
              );
            },
          ),
          divider(),
          Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  dense: true,
                  title: Text(AppLocalizations.of(context).notifications),
                  leading: Icon(Icons.notifications),
                  onTap: () {},
                ),
              ),
              BlocBuilder(
                bloc: _notificationBloc,
                builder: (context, state) {
                  if (state is LoadingState) {
                    return Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.only(left: 25),
                        child: CircularProgressIndicator()
                    );
                  }
                  if (state is ActiveNotificationState) {
                    return Container(
                      width: 60,
                      margin: EdgeInsets.only(left: 20),
                      child: Switch(
                        value: true,
                        onChanged: (value) {
                            isSwitched = value;
                            if (isSwitched) {
                              _notificationBloc.add(
                                  ActiveNotificationEvent(token: token));
                            } else {
                              _notificationBloc.add(
                                  DisActiveNotificationEvent(token: token));
                            }
                        },
                        activeTrackColor: Color(0xffE7ECED),
                        activeColor: Color(0xff34C961),
                      ),
                    );
                  }
                  if (state is DisActiveNotificationState) {
                    return Container(
                      width: 60,
                      margin: EdgeInsets.only(left: 20),
                      child: Switch(
                        value: false,
                        onChanged: (value) {
                            isSwitched = value;
                            if (isSwitched) {
                              _notificationBloc.add(
                                  ActiveNotificationEvent(token: token));
                            } else {
                              _notificationBloc.add(
                                  DisActiveNotificationEvent(token: token));
                            }
                        },
                        activeTrackColor: Color(0xffE7ECED),
                        activeColor: Color(0xff34C961),
                      ),
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
          divider(),
        ],
      ),
    );
  }

  Divider divider() => const Divider(
        height: 1,
      );
}
