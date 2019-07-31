import 'package:flutter/material.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/screens/settings/setting_bloc.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = DependenciesProvider.provide();

    _bloc.dispatch(LoadCurrentLanguage());
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
                                      _bloc.dispatch(ChangeLanguage('ar'));
                                      Navigator.pop(context);
                                    },
                                    dense: true,
                                    selected: state.languageCode == "ar",
                                  ),
                                  ListTile(
                                    title: Text(
                                        AppLocalizations.of(context).english),
                                    onTap: () {
                                      _bloc.dispatch(ChangeLanguage('en'));
                                      Navigator.pop(context);
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
          ListTile(
            dense: true,
            title: Text(AppLocalizations.of(context).notifications),
            leading: Icon(Icons.notifications),
            onTap: () {},
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
