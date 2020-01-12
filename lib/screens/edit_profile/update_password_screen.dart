import 'package:flutter/material.dart';
import 'package:justcost/screens/edit_profile/password.dart';
import 'package:justcost/screens/reset_password/reset_account_screen.dart';
import 'package:justcost/i10n/app_localizations.dart';

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _currentPasswordController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void close() {
    super.dispose();
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).updatePassword),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            autovalidate: true,
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _passwordController,
                    validator: (text) {
                      if (text.isEmpty)
                        return AppLocalizations.of(context)
                            .newPasswordFieldEmptyError;
                      else if (_passwordController.text !=
                          _confirmPasswordController.text)
                        return AppLocalizations.of(context)
                            .passwordMismatchError;
                      else
                        return null;
                    },
                    obscureText: true,
                    minLines: 1,
                    decoration: InputDecoration(
                        hintText: '**********',
                        labelText:
                            AppLocalizations.of(context).newPasswordFieldHint,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    validator: (text) {
                      if (text.isEmpty)
                        return AppLocalizations.of(context)
                            .newPasswordConfirmFieldEmptyError;
                      else if (_passwordController.text !=
                          _confirmPasswordController.text)
                        return AppLocalizations.of(context)
                            .passwordMismatchError;
                      else
                        return null;
                    },
                    obscureText: true,
                    minLines: 1,
                    decoration: InputDecoration(
                        hintText: '**********',
                        labelText: AppLocalizations.of(context)
                            .confirmPasswordFieldHint,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _currentPasswordController,
                    validator: (text) {
                      if (text.isEmpty)
                        return AppLocalizations.of(context)
                            .typeOldPasswordError;
                      else
                        return null;
                    },
                    obscureText: true,
                    minLines: 1,
                    decoration: InputDecoration(
                        hintText: '**********',
                        labelText: AppLocalizations.of(context).currentPassword,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  /*OutlineButton(
                    child: Text('Forgot password? Reset it now'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen()));
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),*/
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          AppLocalizations.of(context).changePasswordSubtitle,
                          style: TextStyle(
                            color: Theme.of(context).errorColor,
                          ))),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (_formKey.currentState.validate()) {
                            Password password = Password(
                                _passwordController.text,
                                _currentPasswordController.text,
                                _confirmPasswordController.text);
                            Navigator.of(context).pop(password);
                          }
                        },
                        child: Text(AppLocalizations.of(context).submitButton),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      OutlineButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.of(context).pop(null);
                        },
                        child: Text(MaterialLocalizations.of(context)
                            .cancelButtonLabel),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
