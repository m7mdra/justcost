import 'package:flutter/material.dart';
import 'package:justcost/i10n/app_localizations.dart';

class SettingsWidget extends StatelessWidget {
  final VoidCallback onLogout;

  const SettingsWidget({Key key, this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context).settings,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),

        ListTile(
          dense: true,
          title: Text(AppLocalizations.of(context).logout),
          onTap: () {
            onLogout();
          },
        ),
      ],
    );
  }

  Divider divider() => const Divider(
        height: 1,
      );
}
