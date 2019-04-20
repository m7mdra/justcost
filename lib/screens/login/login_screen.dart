import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/main.dart';
import 'package:justcost/screens/home/main_screen.dart';
import 'package:justcost/screens/register/register_screen.dart';
import 'package:justcost/screens/reset_password/reset_account_screen.dart';
import 'package:justcost/screens/verification/account_verification_screen.dart';
import 'package:justcost/widget/progress_dialog.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';
import 'login_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _userNameController;
  TextEditingController _passwordController;
  FocusNode _passwordFocusNode = FocusNode();
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _loginBloc = LoginBloc(
        DependenciesProvider.provide(), DependenciesProvider.provide());
    _loginBloc.state.listen((state) {
      print(state);
      if (state is LoginLoading)
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => ProgressDialog(
                  message: AppLocalizations.of(context).loginLoadingMessage,
                ));
      if (state is LoginError) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) => RoundedAlertDialog(
                  title: Text(AppLocalizations.of(context).generalError),
                  content: Text(state.message),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        MaterialLocalizations.of(context).okButtonLabel,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
      if (state is LoginSuccess) {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      }
      if (state is GuestLoginSuccess)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      if (state is AccountNotVerified)
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AccountVerificationScreen()));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _loginBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Align(
              child: Text(
                'JUST COST',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              child: Text(
                AppLocalizations.of(context).loginScreenName,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (username) {
                        return username.isEmpty
                            ? AppLocalizations.of(context)
                                .usernameFieldEmptyError
                            : null;
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      textInputAction: TextInputAction.next,
                      controller: _userNameController,
                      minLines: 1,
                      decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context).usernameFieldHint,
                          labelText:
                              AppLocalizations.of(context).usernameFieldHint,
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16))),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      obscureText: true,
                      validator: (password) {
                        return password.isEmpty
                            ? AppLocalizations.of(context)
                                .passwordFieldEmptyError
                            : null;
                      },
                      onEditingComplete: () => _attemptLogin(),
                      minLines: 1,
                      decoration: InputDecoration(
                          hintText: '**********',
                          labelText:
                              AppLocalizations.of(context).passwordFieldHint,
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16))),
                    ),
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MaterialButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen()));
                  },
                  child: Text(
                    AppLocalizations.of(context).forgotPasswordButton,
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              onPressed: () => _attemptLogin(),
              child: Text(AppLocalizations.of(context).loginScreenName),
              color: Theme.of(context).accentColor,
            ),
            const Divider(),
            OutlineButton(
              onPressed: () {
                _loginBloc.dispatch(GuestLogin());
              },
              child: Text(AppLocalizations.of(context).continueAsGuestButton),
            ),
            OutlineButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
              child: Text(AppLocalizations.of(context).createAccountButton),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).aboutUsButton,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                Text(' | '),
                Text(
                  AppLocalizations.of(context).getHelp,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Center(
                child: Text(
              AppLocalizations.of(context).appVersion('1.1'),
            )),
            const SizedBox(
              height: 2,
            ),
            Center(
                child: Text(AppLocalizations.of(context)
                    .copyRights(DateTime.now().year))),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).privacy,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                Text(' | '),
                Text(
                  AppLocalizations.of(context).tos,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future _attemptLogin() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState.validate()) {
      _loginBloc.dispatch(UserLogin(_userNameController.text,
          _passwordController.text, await FirebaseMessaging().getToken()));
    }
  }
}
