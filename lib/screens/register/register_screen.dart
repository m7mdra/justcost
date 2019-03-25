import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File imageFile;
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

  @override
  void initState() {
    super.initState();
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
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Align(
              child: ClipOval(
                  child: imageFile == null
                      ? Image.network(
                          'https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_960_720.png',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          imageFile,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )),
            ),
            Align(

              child: OutlineButton.icon(
                label: Text('Select Profile Avatar'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          title: Text('Select Media to add to the uploads'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text('Capture Image'),
                                leading: Icon(Icons.camera_alt),
                                dense: true,
                                onTap: () async {
                                  Navigator.pop(context);
                                  var image = await ImagePicker.pickImage(
                                      source: ImageSource.camera);
                                  setState(() {
                                    imageFile = image;
                                  });
                                },
                              ),
                              ListTile(
                                title: Text('Pick Image from gallery'),
                                leading: Icon(Icons.image),
                                dense: true,
                                onTap: () async {
                                  Navigator.pop(context);
                                  var image = await ImagePicker.pickImage(
                                      source: ImageSource.gallery);
                                  setState(() {
                                    imageFile = image;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      });
                },
                icon: Icon(Icons.camera_alt),
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
                        icon: Icon(Icons.person),

                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Username',
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
                        icon: Icon(Icons.mail),

                        contentPadding: EdgeInsets.all(10),
                        hintText: 'mail@domain.com',
                        labelText: 'E-mail address',
                        errorMaxLines: 1,
                        filled: true,
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
                      icon: Icon(Icons.phone),
                        contentPadding: EdgeInsets.all(10),
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
                        icon: Icon(Icons.location_on),

                        contentPadding: EdgeInsets.all(10),
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
                        icon: Icon(Icons.https),
                        errorMaxLines: 1,
                        contentPadding: EdgeInsets.all(10),
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
              padding: const EdgeInsets.only(left: 16.0,right:16.0),
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
      print(_userNameController);
      print(_passwordController);
      print(_emailController);
      print(_phoneNumberController);
      print(_addressController);
    }else {
      Future.delayed(Duration(seconds: 2)).then((_){
        setState(() {
          _formKey.currentState.reset();
        });
      });
    }
  }
}
