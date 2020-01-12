import 'package:flutter/material.dart';
import 'package:justcost/screens/edit_profile/account_information.dart';
import 'package:justcost/i10n/app_localizations.dart';

class UpdateAccountInformationScreen extends StatefulWidget {
  final AccountInformation accountInformation;

  const UpdateAccountInformationScreen([this.accountInformation])
      : super(key: const Key('value'));

  @override
  _UpdateAccountInformationScreenState createState() =>
      _UpdateAccountInformationScreenState();
}

class _UpdateAccountInformationScreenState
    extends State<UpdateAccountInformationScreen> {
  TextEditingController _usernameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex;

  @override
  void initState() {
    super.initState();
    regex = new RegExp(pattern);

    _usernameController =
        TextEditingController(text: widget.accountInformation.username);
    _emailController =
        TextEditingController(text: widget.accountInformation.email);
    _passwordController =
        TextEditingController(text: widget.accountInformation.currentPassword);
  }

  @override
  void close() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${AppLocalizations.of(context).updateAccountInformation}"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  scrollPadding: EdgeInsets.all(0),
                  maxLines: 1,
                  validator: (username) {
                    return username.isEmpty
                        ? AppLocalizations.of(context).usernameFieldEmptyError
                        : null;
                  },
                  controller: _usernameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      contentPadding: EdgeInsets.all(10),
                      hintText: AppLocalizations.of(context).usernameFieldHint,
                      prefixText: '@',
                      labelText: AppLocalizations.of(context).usernameFieldHint,
                      errorMaxLines: 1,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _emailController,
                  maxLines: 1,
                  validator: (mail) {
                    if (mail.isEmpty)
                      return AppLocalizations.of(context).emailFieldEmptyError;
                    else if (!regex.hasMatch(mail))
                      return AppLocalizations.of(context)
                          .emailFieldInvalidError;
                    else
                      return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail),
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'mail@domain.com',
                      labelText: AppLocalizations.of(context).emailFieldLabel,
                      errorMaxLines: 1,
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          gapPadding: 0.0,
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _passwordController,
                  validator: (password) {
                    return password.isEmpty
                        ? AppLocalizations.of(context).passwordFieldEmptyError
                        : null;
                  },
                  maxLines: 1,
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.https),
                      errorMaxLines: 1,
                      contentPadding: EdgeInsets.all(8),
                      hintText: '**********',
                      labelText: AppLocalizations.of(context).passwordFieldHint,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (_formKey.currentState.validate()) {
                          AccountInformation information = AccountInformation(
                              _usernameController.text, _emailController.text,
                              currentPassword: _passwordController.text);
                          Navigator.of(context).pop(information);
                        }
                      },
                      child: Text(AppLocalizations.of(context).submitButton),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    OutlineButton(
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                      child: Text(
                          MaterialLocalizations.of(context).cancelButtonLabel),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
