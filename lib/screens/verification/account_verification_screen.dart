import 'package:flutter/material.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/home/main_screen.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/widget/progress_dialog.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';
import 'account_verification_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/main.dart';

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
    _accountVerificationBloc = AccountVerificationBloc(DependenciesProvide.provide(), DependenciesProvide.provide());
    _textEditingController = TextEditingController();
    _accountVerificationBloc.state.listen((state) {
      if (state is VerificationLoading)
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ProgressDialog(
                  message: "Please wait...",
                ));
      if (state is ResendVerificationFailed) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) => RoundedAlertDialog(
                  title: Text('Error'),
                  content: Text(state.message),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
      if (state is AccountVerificationFailed) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) => RoundedAlertDialog(
                    title: Text('Error'),
                    content: Text(state.message),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ]));
      }
      if (state is SessionExpiredState) {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => RoundedAlertDialog(
              content: Text('Session Expired, log in again'),
            )).then((_) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen()));
        });
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
        child: BlocProvider(
          bloc: _accountVerificationBloc,
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
            'Account Verified Successfully.',
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
            child: Text('Continue'),
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
            Center(child: Text('Didnt receive email?')),
            const SizedBox(
              height: 8,
            ),
            Center(
              child: OutlineButton(
                highlightedBorderColor: Colors.yellow,
                child: Text('Resend'),
                onPressed: () {
                  _accountVerificationBloc.dispatch(ResendVerification());
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
        SizedBox(
          height: 16,
        ),
        Padding(
          padding:
              const EdgeInsets.only(right: 16, left: 16, top: 8, bottom: 8),
          child: Form(
            key: _formKey,
            child: TextFormField(
              validator: (text) {
                if (text.isEmpty)
                  return 'Verification code Field is Empty';
                else
                  return null;
              },
              controller: _textEditingController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(12),
                  labelText: 'Verification Code',
                  hintText: '0000',
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
            else {
              Future.delayed(Duration(seconds: 2))
                  .then((_) => _formKey.currentState.reset());
            }
          },
          child: Text('Submit Code'),
        ),
      ],
    );
  }
}
