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
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
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
    _textEditingController.dispose();
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
              if (state is ResetLoadingState)
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              if (state is ResetSuccessState)
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Center(
                        child: Icon(Icons.check_circle,
                            size: 80, color: Colors.green)),
                    Text(AppLocalizations.of(context).resetAccount,
                        style: Theme.of(context).textTheme.title),
                    Text(AppLocalizations.of(context).resetAccountSuccess),
                    OutlineButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context).continueButton),
                    )
                  ],
                );
              return buildIdleState(context);
            },
          ),
        ),
      ),
    );
  }

  Widget buildIdleState(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.account_circle,
          size: 80,
        ),
        Text(AppLocalizations.of(context).resetAccount,
            style: Theme.of(context).textTheme.title),
        Text(
          AppLocalizations.of(context).resetAccountInstruction,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 8,
        ),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _textEditingController,
            validator: (mail) {
              if (mail.isEmpty)
                return AppLocalizations.of(context).emailFieldEmptyError;
              else if (!regex.hasMatch(mail))
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
        RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () {
            var form = _formKey.currentState;
            var email = _textEditingController.text;
            if (form.validate()) _bloc.dispatch(SubmitEmailEvent(email));
          },
          child: Text(AppLocalizations.of(context).submitButton),
          color: Theme.of(context).accentColor,
        ),
      ],
    );
  }
}
