import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:justcost/data/city/model/city.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/city/city_picker_screen.dart';
import 'package:justcost/screens/legal/privacy_policy_screen.dart';
import 'package:justcost/screens/register/register_bloc.dart';
import 'package:justcost/screens/verification/account_verification_screen.dart';
import 'package:justcost/widget/progress_dialog.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _userNameController;
  TextEditingController _passwordController;
  TextEditingController _emailController;
  TextEditingController _phoneNumberController;
  TextEditingController _nameController;
  TextEditingController _cityController;
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex;
  City city;
  final _formKey = GlobalKey<FormState>();
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();
  FocusNode _mailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();
  RegisterBloc _registerBloc;
  String genderGroupValue;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _registerBloc = RegisterBloc(
        DependenciesProvider.provide(), DependenciesProvider.provide());
    _registerBloc.state.listen((state) {
      if (state is RegisterLoading)
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ProgressDialog(
                  message:
                      AppLocalizations.of(context).createAccountLoadingMessage,
                ));
      if (state is RegisterError) {
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
      if (state is RegisterSuccess) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AccountVerificationScreen()));
      }
    });
    regex = new RegExp(pattern);

    _userNameController = TextEditingController();

    _nameController = TextEditingController();

    _passwordController = TextEditingController();

    _emailController = TextEditingController();

    _phoneNumberController = TextEditingController();

    _cityController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _registerBloc.dispose();
    _usernameFocusNode.dispose();
    _mailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _cityController.dispose();

    _nameController.dispose();
    _cityFocusNode.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.all(8),
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
                AppLocalizations.of(context).accountCreation,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                      maxLines: 1,
                      controller: _nameController,
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(_usernameFocusNode),
                      validator: (name) {
                        if (name.isEmpty)
                          return 'Name field can not be empty';
                        else
                          return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          contentPadding: EdgeInsets.all(10),
                          labelText: 'Full Name',
                          errorMaxLines: 1,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)))),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    scrollPadding: EdgeInsets.all(0),
                    maxLines: 1,
                    focusNode: _usernameFocusNode,
                    validator: (username) {
                      return username.isEmpty
                          ? AppLocalizations.of(context).usernameFieldEmptyError
                          : null;
                    },
                    controller: _userNameController,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(_mailFocusNode);
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        contentPadding: EdgeInsets.all(10),
                        hintText:
                            AppLocalizations.of(context).usernameFieldHint,
                        prefixText: '@',
                        labelText:
                            AppLocalizations.of(context).usernameFieldHint,
                        errorMaxLines: 1,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _emailController,
                    focusNode: _mailFocusNode,
                    maxLines: 1,
                    validator: (mail) {
                      if (mail.isEmpty)
                        return AppLocalizations.of(context)
                            .emailFieldEmptyError;
                      else if (!regex.hasMatch(mail))
                        return AppLocalizations.of(context)
                            .emailFieldInvalidError;
                      else
                        return null;
                    },
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      FocusScope.of(context)
                          .requestFocus(_phoneNumberFocusNode);
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        contentPadding: EdgeInsets.all(10),
                        hintText: AppLocalizations.of(context).emailFieldHint,
                        labelText: AppLocalizations.of(context).emailFieldHint,
                        errorMaxLines: 1,
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            gapPadding: 0.0,
                            borderSide: BorderSide(
                                color: Theme.of(context).errorColor)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    focusNode: _phoneNumberFocusNode,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    validator: (phone) {
                      return phone.isEmpty
                          ? AppLocalizations.of(context).phoneNumberEmptyError
                          : null;
                    },
                    keyboardType: TextInputType.phone,
                    controller: _phoneNumberController,
                    onEditingComplete: () {},
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        contentPadding: EdgeInsets.all(8),
                        hintText: '000-0000-0000',
                        labelText:
                            AppLocalizations.of(context).phoneNumberField,
                        prefixText: '+',
                        errorMaxLines: 1,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          enabled: false,
                          enableInteractiveSelection: false,
                          focusNode: _cityFocusNode,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          validator: (city) {
                            return city.isEmpty
                                ? AppLocalizations.of(context)
                                    .phoneNumberEmptyError
                                : null;
                            //TODO: change error message.
                          },
                          controller: _cityController,
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.location_city),
                              contentPadding: EdgeInsets.all(8),
                              hintText: 'ie: Dubai, Abu Dhabi',
                              labelText: 'City',
                              errorMaxLines: 1,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      OutlineButton(
                        onPressed: () async {
                          City city = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => CityPickerScreen()));
                          if (city != null) {
                            setState(() {
                              this.city = city;
                            });
                            _cityController.text = city.name;
                          }
                        },
                        child: Text('Pick City'),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    focusNode: _passwordFocusNode,
                    controller: _passwordController,
                    validator: (password) {
                      if (password.isEmpty)
                        return AppLocalizations.of(context)
                            .passwordFieldEmptyError;
                      else if (password.length < 6)
                        return 'Password can not be less than 6 characters';
                      else
                        return null;
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _attemptRegister();
                    },
                    maxLines: 1,
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.https),
                        errorMaxLines: 1,
                        contentPadding: EdgeInsets.all(8),
                        hintText: '**********',
                        labelText:
                            AppLocalizations.of(context).passwordFieldHint,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                ],
              ),
              key: _formKey,
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Gender',
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  RadioListTile<String>(
                      value: 'male',
                      groupValue: genderGroupValue,
                      title: Text('Male'),
                      dense: true,
                      onChanged: (value) =>
                          setState(() => genderGroupValue = value)),
                  RadioListTile<String>(
                      value: 'female',
                      groupValue: genderGroupValue,
                      title: Text('Female'),
                      dense: true,
                      onChanged: (value) =>
                          setState(() => genderGroupValue = value)),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: Theme.of(context).textTheme.caption,
                        children: [
                          TextSpan(
                            text: 'By Registering you agree on ',
                          ),
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          PrivacyPolicyScreen()));
                                },
                              text: 'Terms of Conditions',
                              style: TextStyle(
                                  color: Colors.yellow[900],
                                  decoration: TextDecoration.underline)),
                          TextSpan(
                            text: ' And',
                          ),
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          PrivacyPolicyScreen()));
                                },
                              text: ' Privacy Policy',
                              style: TextStyle(
                                  color: Colors.yellow[900],
                                  decoration: TextDecoration.underline)),
                        ]))),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: _attemptRegister,
                child: Text(AppLocalizations.of(context).createAccountButton),
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _attemptRegister() async {
    if (_formKey.currentState.validate()) {
      _registerBloc.dispatch(UserRegister(
          name: _nameController.text.trim(),
          username: _userNameController.text.trim(),
          email: _emailController.text.trim(),
          messagingId: await FirebaseMessaging().getToken(),
          password: _passwordController.text.trim(),
          city: city,
          phoneNumber: _phoneNumberController.text.trim()));
    }
  }
}
