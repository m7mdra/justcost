import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/image_cropper_screen.dart';
import 'package:justcost/main.dart';
import 'package:justcost/screens/home/main_screen.dart';
import 'package:justcost/screens/register/register_bloc.dart';
import 'package:justcost/screens/verification/account_verification_screen.dart';
import 'package:justcost/widget/progress_dialog.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';
import 'package:justcost/dependencies_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _userNameController;
  TextEditingController _passwordController;
  TextEditingController _emailController;
  TextEditingController _phoneNumberController;
  TextEditingController _addressController;
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex;
  final _formKey = GlobalKey<FormState>();
  FocusNode _mailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();
  RegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _registerBloc = RegisterBloc(DependenciesProvide.provide(), DependenciesProvide.provide());
    _registerBloc.state.listen((state) {
      if (state is RegisterLoading)
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ProgressDialog(
                  message: "Please wait while creating account...",
                ));
      if (state is RegisterError) {
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
      if (state is RegisterSuccess) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AccountVerificationScreen()));
      }
    });
    regex = new RegExp(pattern);
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _registerBloc.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    scrollPadding: EdgeInsets.all(0),
                    maxLines: 1,
                    validator: (username) {
                      return username.isEmpty
                          ? "Username field can not be empty"
                          : null;
                    },
                    controller: _userNameController,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(_mailFocusNode);
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        contentPadding: EdgeInsets.all(8),
                        hintText: 'Username',
                        prefixText: '@',
                        labelText: 'Username',
                        errorMaxLines: 1,
                        filled: true,
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
                        return "Email Field can not be empty";
                      else if (!regex.hasMatch(mail))
                        return "Invalid email address";
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
                        contentPadding: EdgeInsets.all(8),
                        hintText: 'mail@domain.com',
                        labelText: 'E-mail address',
                        errorMaxLines: 1,
                        filled: true,
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
                          ? "Phone Number field can not be empty"
                          : null;
                    },
                    keyboardType: TextInputType.phone,
                    controller: _phoneNumberController,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(_addressFocusNode);
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        contentPadding: EdgeInsets.all(8),
                        hintText: '000-0000-0000',
                        labelText: 'Phone Number',
                        prefixText: '+',
                        errorMaxLines: 1,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    maxLines: 1,
                    focusNode: _addressFocusNode,
                    controller: _addressController,
                    validator: (address) {
                      return address.isEmpty
                          ? "Address Field can not be empty"
                          : null;
                    },
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_on),
                        contentPadding: EdgeInsets.all(8),
                        hintText: 'Address',
                        labelText: 'Address',
                        filled: true,
                        errorMaxLines: 1,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    focusNode: _passwordFocusNode,
                    controller: _passwordController,
                    validator: (password) {
                      return password.isEmpty
                          ? "Password field can not be empty"
                          : null;
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _attemptRegister();
                    },
                    maxLines: 1,
                    obscureText: true,
                    decoration: InputDecoration(
                        filled: true,
                        prefixIcon: Icon(Icons.https),
                        errorMaxLines: 1,
                        contentPadding: EdgeInsets.all(8),
                        hintText: '**********',
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                ],
              ),
              key: _formKey,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: _attemptRegister,
                child: Text('REGISTER'),
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _attemptRegister() {
    if (_formKey.currentState.validate()) {
      _registerBloc.dispatch(UserRegister(
          username: _userNameController.text.trim(),
          address: _addressController.text.trim(),
          email: _emailController.text.trim(),
          messagingId: "34",
          //TODO: implement messing token id
          password: _passwordController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim()));
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) {
        setState(() {
          _formKey.currentState.reset();
        });
      });
    }
  }
}
