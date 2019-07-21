import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/home/main_screen.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/widget/progress_dialog.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';

import 'account_verification_bloc.dart';

class AccountVerificationScreen extends StatefulWidget {
  @override
  _AccountVerificationScreenState createState() =>
      _AccountVerificationScreenState();
}

class _AccountVerificationScreenState extends State<AccountVerificationScreen> {
  AccountVerificationBloc _accountVerificationBloc;
  TextEditingController _textEditingController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _accountVerificationBloc = AccountVerificationBloc(
        DependenciesProvider.provide(), DependenciesProvider.provide());
    _textEditingController = TextEditingController();
    _accountVerificationBloc.state.listen((state) {
      if (state is VerificationLoading)
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ProgressDialog(
                  message:
                      AppLocalizations.of(context).verificationLoadingMessage,
                ));
      if (state is ResendVerificationFailed) {
        Navigator.of(context).pop();
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
      if (state is VerificationSentSuccess) Navigator.of(context).pop();

      if (state is AccountVerificationFailed) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) => RoundedAlertDialog(
                    title: Text(AppLocalizations.of(context).generalError),
                    content: Text(state.message),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                            MaterialLocalizations.of(context).okButtonLabel),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ]));
      }
      if (state is SessionExpiredState) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                LoginScreen(NavigationReason.session_expired)));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _accountVerificationBloc.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider.value(
          value: _accountVerificationBloc,
          child: BlocBuilder(
              bloc: _accountVerificationBloc,
              builder: (context, state) {
                if (state is VerificationSentSuccess)
                  return buildVerificationWidget();
                if (state is AccountVerifiedSuccessfully) {
                  Navigator.of(context).pop();
                  return buildSuccessState(context);
                }

                return buildIdleState(context);
              }),
        ),
      ),
    );
  }

  Widget buildSuccessState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 80,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            AppLocalizations.of(context).accountVerifiedSuccess,
            style: Theme.of(context).textTheme.title,
          ),
          const SizedBox(
            height: 8,
          ),
          OutlineButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainScreen()));
            },
            child: Text(AppLocalizations.of(context).continueButton),
          )
        ],
      ),
    );
  }

  Widget buildIdleState(BuildContext context) {
    return SafeArea(
      child: Align(
        child: ListView(
          children: <Widget>[
            buildVerificationWidget(),
            const SizedBox(
              height: 8,
            ),
            Center(child: Text(AppLocalizations.of(context).didntReceiveSms)),
            const SizedBox(
              height: 8,
            ),
            Center(
              child: OutlineButton(
                highlightedBorderColor: Colors.yellow,
                child: Text(AppLocalizations.of(context).resendButton),
                onPressed: () {
                  _accountVerificationBloc.dispatch(ResendVerification());
                },
                splashColor: Theme.of(context).accentColor,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Center(
              child: FlatButton(
                child: Text(AppLocalizations.of(context).logoutButton),
                onPressed: () {
                  _accountVerificationBloc.dispatch(LogoutEvent());
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          LoginScreen(NavigationReason.logout)));
                },
                splashColor: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVerificationWidget() {
    return Column(
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
          AppLocalizations.of(context).accountVerificationHeading,
          style: Theme.of(context).textTheme.title,
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0),
          child: Text(
            AppLocalizations.of(context).accountVerificationSubhead,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.body1,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding:
              const EdgeInsets.only(right: 64, left: 64, top: 8, bottom: 8),
          child: Form(
            key: _formKey,
            child: TextFormField(
              maxLines: 1,
              maxLengthEnforced: true,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              validator: (text) {
                if (text.isEmpty)
                  return AppLocalizations.of(context)
                      .verificationFieldEmptyError;
                else
                  return null;
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(6),
                WhitelistingTextInputFormatter(RegExp('[0-9]'))
              ],
              controller: _textEditingController,
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  contentPadding: const EdgeInsets.all(12),
                  labelText:
                      AppLocalizations.of(context).verificationCodeFieldHint,
                  hintText: '******',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)))),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        RaisedButton(
          onPressed: () {
            var code = _textEditingController.text;
            if (_formKey.currentState.validate())
              _accountVerificationBloc.dispatch(SubmitVerificationCode(code));
          },
          child: Text(AppLocalizations.of(context).submitButton),
        ),
      ],
    );
  }
}
