import 'package:flutter/material.dart';
import 'package:justcost/screens/edit_profile/password.dart';
import 'package:justcost/screens/reset_password/reset_account_screen.dart';

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
  void dispose() {
    super.dispose();
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update password'),
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
                        return 'New password Field is required.';
                      else if (_passwordController.text !=
                          _confirmPasswordController.text)
                        return 'Password mismatch';
                      else
                        return null;
                    },
                    obscureText: true,
                    minLines: 1,
                    decoration: InputDecoration(
                        hintText: '**********',
                        labelText: 'New Password',
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
                        return 'New Password confirmation is required.';
                      else if (_passwordController.text !=
                          _confirmPasswordController.text)
                        return 'Password mismatch';
                      else
                        return null;
                    },
                    obscureText: true,
                    minLines: 1,
                    decoration: InputDecoration(
                        hintText: '**********',
                        labelText: 'Confirm New Password',
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
                        return 'Type old password for safity measurement';
                      else
                        return null;
                    },
                    obscureText: true,
                    minLines: 1,
                    decoration: InputDecoration(
                        hintText: '**********',
                        labelText: 'Current Password',
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  OutlineButton(
                    child: Text('Forgot password? Reset it now'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen()));
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          'Changing password will terminate the current session',
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
                        child: Text('Submit'),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      OutlineButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.of(context).pop(null);
                        },
                        child: Text('Cancel'),
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
