import 'package:flutter/material.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/screens/register/register_screen.dart';
import 'package:justcost/i10n/app_localizations.dart';

class GuestUserWidget extends StatelessWidget {
  const GuestUserWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[

        Text(
          AppLocalizations.of(context).guestAccountMessage,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subhead,
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text(
                AppLocalizations.of(context).loginScreenName.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).accentColor,
              textTheme: ButtonTextTheme.primary,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
              child: Text(
                  AppLocalizations.of(context)
                      .createAccountButton
                      .toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              color: Theme.of(context).accentColor,
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        )
      ],
    );
  }
}
