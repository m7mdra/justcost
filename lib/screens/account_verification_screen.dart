import 'package:flutter/material.dart';

class AccountVerificationScreen extends StatefulWidget {
  @override
  _AccountVerificationScreenState createState() =>
      _AccountVerificationScreenState();
}

class _AccountVerificationScreenState extends State<AccountVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(
                Icons.verified_user,
                size: 80,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Account Verficiation is required.',
                style: Theme.of(context).textTheme.title,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'An E-mail address was sent to your account containg instruction to verify you account',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.body1,
              ),
              const SizedBox(
                height: 8,
              ),
              Text('Didnt receive email?'),
              const SizedBox(
                height: 8,
              ),
              FlatButton(
                child: Text('Resend'),
                onPressed: () {},
                splashColor: Theme.of(context).accentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
