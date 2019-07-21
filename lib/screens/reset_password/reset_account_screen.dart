import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';

import 'reset_account_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  ResetAccountBloc _bloc;
  GlobalKey<FormState> _formKey;
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex;
  TextEditingController _phoneNumberTextController;
  TextEditingController _emailTextController;
  TextEditingController _resetCodeTextController;

  @override
  void initState() {
    super.initState();
    _phoneNumberTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _resetCodeTextController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _bloc = ResetAccountBloc(DependenciesProvider.provide());
    _bloc.state.listen((state) {
      if (state is ResetErrorState) {
        showDialog(
            context: context,
            builder: (context) => RoundedAlertDialog(
                  title: Text(AppLocalizations.of(context).generalError),
                  content: Text(state.message),
                  actions: <Widget>[
                    FlatButton(
                      child:
                          Text(MaterialLocalizations.of(context).okButtonLabel),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
    });
    regex = new RegExp(pattern);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _phoneNumberTextController.dispose();
    _emailTextController.dispose();
    _resetCodeTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder(
            bloc: _bloc,
            builder: (context, state) {
              if (state is PhoneNumberResetSelectedState)
                return buildPhoneNumberResetState(context);
              if (state is EmailResetSelectedState)
                return buildEmailResetState(context);
              return buildSelectState();
            },
          ),
        ),
      ),
    );
  }

  Column buildPhoneCodeForm(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(
          Icons.sms,
          size: 60,
        ),
        Text(
          AppLocalizations.of(context).resetSuccessTitle,
          style: Theme.of(context).textTheme.title,
        ),
        SizedBox(
          height: 8,
        ),
        Text.rich(
          TextSpan(children: [
            TextSpan(
              text: 'We sent a message to ',
            ),
            TextSpan(
                text: '+1231231231',
                style: TextStyle(decoration: TextDecoration.underline)),
            TextSpan(text: ' containing '),
            TextSpan(
                text: '5',
                style: TextStyle(decoration: TextDecoration.underline)),
            TextSpan(text: ' digit code write it below to verify that its you.')
          ]),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body1,
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 64, right: 64),
          child: TextField(
            maxLength: 5,
            maxLines: 1,
            maxLengthEnforced: true,
            autofocus: true,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        OutlineButton(
          onPressed: () {},
          child: Text('Submit'),
        )
      ],
    );
  }

  Column buildEmailForm(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(
          Icons.sms,
          size: 60,
        ),
        Text(
          AppLocalizations.of(context).resetSuccessTitle,
          style: Theme.of(context).textTheme.title,
        ),
        SizedBox(
          height: 8,
        ),
        Text.rich(
          TextSpan(children: [
            TextSpan(
              text: 'We sent a message to ',
            ),
            TextSpan(
                text: 'Mail@domain.com',
                style: TextStyle(decoration: TextDecoration.underline)),
            TextSpan(text: ' containing '),
            TextSpan(
                text: '5',
                style: TextStyle(decoration: TextDecoration.underline)),
            TextSpan(text: ' digit code write it below to verify that its you.')
          ]),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body1,
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 64, right: 64),
          child: TextField(
            maxLength: 5,
            maxLines: 1,
            maxLengthEnforced: true,
            autofocus: true,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        OutlineButton(
          onPressed: () {},
          child: Text('Submit'),
        )
      ],
    );
  }

  Widget buildSelectState() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.account_circle,
            size: 80,
          ),
          Text(
            'Reset Account',
            style: Theme.of(context).textTheme.title,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'To Reset your account you can use Phone number or '
            'E-mail address associated with the account.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.body2,
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    _bloc.dispatch(PhoneNumberResetSelected());
                  },
                  child: Text('Use Phone number'),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    _bloc.dispatch(EmailResetSelected());
                  },
                  child: Text('Use Email address'),
                  textColor: Colors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildPhoneNumberResetState(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.phonelink_lock,
          size: 80,
        ),
        Text(AppLocalizations.of(context).resetAccount,
            style: Theme.of(context).textTheme.title),
        Text(
          'Type your Phone number and will send you a sms message'
          ' containing the instructions to reset your account.',
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 16,
        ),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _phoneNumberTextController,
            validator: (mail) {
              if (mail.isEmpty)
                return AppLocalizations.of(context).phoneNumberEmptyError;
              else
                return null;
            },
            maxLines: 1,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                prefixText: '+',
                hintText: '0000-0000-000',
                labelText: AppLocalizations.of(context).phoneNumberField,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16))),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () {
            var form = _formKey.currentState;
            var phone = _phoneNumberTextController.text;
            if (form.validate()) _bloc.dispatch(SubmitPhoneNumber(phone));
          },
          child: Text(AppLocalizations.of(context).submitButton),
          color: Theme.of(context).accentColor,
        ),
      ],
    );
  }

  Widget buildEmailResetState(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.phonelink_lock,
          size: 80,
        ),
        Text(AppLocalizations.of(context).resetAccount,
            style: Theme.of(context).textTheme.title),
        Text(
          'Type your Email Address and will send you an Email message'
          ' containing the instructions to reset your account.',
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 16,
        ),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _emailTextController,
            validator: (mail) {
              if (mail.isEmpty)
                return AppLocalizations.of(context).emailFieldEmptyError;
              if (!regex.hasMatch(mail))
                return AppLocalizations.of(context).emailFieldInvalidError;
              else
                return null;
            },
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hintText: 'mail@domain.com',
                labelText: AppLocalizations.of(context).emailFieldHint,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16))),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () {
            var form = _formKey.currentState;
            var email = _emailTextController.text;
            if (form.validate()) _bloc.dispatch(SubmitEmailEvent(email));
          },
          child: Text(AppLocalizations.of(context).submitButton),
          color: Theme.of(context).accentColor,
        ),
      ],
    );
  }
}
