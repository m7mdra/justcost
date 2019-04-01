import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:justcost/main.dart';
import 'package:justcost/screens/data/user/user_repo.dart';
import 'package:justcost/screens/data/user_sessions.dart';
import 'package:justcost/screens/home/main_screen.dart';
import 'package:justcost/screens/register/register_screen.dart';
import 'package:justcost/screens/reset_password/reset_password_screen.dart';
import 'package:justcost/widget/progress_dialog.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';
import 'login_bloc.dart';

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
    _loginBloc =
        LoginBloc(UserRepository(getIt.get()), getIt.get());
    _loginBloc.state.listen((state) {
      if (state is LoginLoading)
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => ProgressDialog(
              message: "Please wait while trying to login...",
            ));
      if (state is LoginError) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) => RoundedAlertDialog(
              title: Text('Error'),
              content: Text(state.message),
            ));
      }
      if (state is LoginSuccess) {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
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
                'Login',
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
                            ? "Username field can not be empty"
                            : null;
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      textInputAction: TextInputAction.next,
                      controller: _userNameController,
                      minLines: 1,
                      decoration: InputDecoration(
                          hintText: 'Username',
                          labelText: 'Username',
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
                            ? "password field can not be empty"
                            : null;
                      },
                      onEditingComplete: () {
                        var form = _formKey.currentState;
                        attempLogin(form);
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      minLines: 1,
                      decoration: InputDecoration(
                          hintText: '**********',
                          labelText: 'Password',
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
                    'Forgot Password?',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              onPressed: () {
                var form = _formKey.currentState;
                attempLogin(form);
              },
              child: Text('Login'),
              color: Theme.of(context).accentColor,
            ),
            const Divider(),
            OutlineButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MainScreen()));
              },
              child: Text('Continue as guest'),
            ),
            OutlineButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
              child: Text('Register'),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'About us',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                Text(' | '),
                Text(
                  'Get Help',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Center(child: Text('Version 1.0')),
            const SizedBox(
              height: 2,
            ),
            Center(child: Text('Copyright © 2019, All Rights resereved.')),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Privacy',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                Text(' | '),
                Text(
                  'Terms of Service',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void attempLogin(FormState form) {
    if (form.validate()) {
      _loginBloc.dispatch(
          UserLogin(_userNameController.text, _passwordController.text, "123"));
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) {
        _formKey.currentState.reset();
      });
    }
  }
}
