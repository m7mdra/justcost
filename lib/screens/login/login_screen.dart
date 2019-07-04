import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/home/main_screen.dart';
import 'package:justcost/screens/register/register_screen.dart';
import 'package:justcost/screens/verification/account_verification_screen.dart';
import 'package:justcost/widget/progress_dialog.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';

import 'login_bloc.dart';

enum NavigationReason { password_change, session_expired, logout, none }

class LoginScreen extends StatefulWidget {
  final NavigationReason navigationReason;

  const LoginScreen([this.navigationReason = NavigationReason.none])
      : super(key: const Key('m'));

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _userNameController;
  TextEditingController _passwordController;
  FocusNode _passwordFocusNode = FocusNode();
  LoginBloc _loginBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loginBloc = LoginBloc(
        DependenciesProvider.provide(), DependenciesProvider.provide());
    _loginBloc.state.listen((state) {
      if (state is LoginLoading)
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => ProgressDialog(
                  message: AppLocalizations.of(context).loginLoadingMessage,
                ));
      if (state is UserNameOrPasswordInvalid) {
        Navigator.of(context).pop();

        showDialog(
            context: context,
            builder: (context) => RoundedAlertDialog(
                  title: Text('Invalid Credentials'),
                  content: Text(
                      'Check your password/username first then try again.'),
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AccountVerificationScreen()));
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.navigationReason);
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    Future.delayed(Duration(microseconds: 100)).then((_) {
      switch (widget.navigationReason) {
        case NavigationReason.logout:
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context).logoutSuccessMessage),
          ));
          break;

        case NavigationReason.password_change:
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context).passwordChangedSuccessfully),
          ));
          break;
        case NavigationReason.session_expired:
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context).sessionExpiredMessage),
          ));
          break;
        case NavigationReason.none:
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _loginBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/icon/android/justcost-title.png',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Hero(
              tag: "form",
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
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
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
                            },
                            textInputAction: TextInputAction.next,
                            controller: _userNameController,
                            minLines: 1,
                            decoration: InputDecoration(
                                labelStyle: Theme.of(context).textTheme.body1,
                                hintText: AppLocalizations.of(context)
                                    .usernameFieldHint,
                                labelText: AppLocalizations.of(context)
                                    .usernameFieldHint,
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.redAccent, width: 0.5),
                                    borderRadius: BorderRadius.circular(2))),
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
                                labelStyle: Theme.of(context).textTheme.body1,
                                labelText: AppLocalizations.of(context)
                                    .passwordFieldHint,
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.redAccent, width: 0.5),
                                    borderRadius: BorderRadius.circular(2))),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              onPressed: () => _attemptLogin(),
                              child: Text(
                                  AppLocalizations.of(context).loginScreenName),
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
              child: Text(AppLocalizations.of(context).createAccountButton),
            ),
            FlatButton(
              onPressed: () {
                _loginBloc.dispatch(GuestLogin());
              },
              child: Text(AppLocalizations.of(context).continueAsGuestButton),
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
