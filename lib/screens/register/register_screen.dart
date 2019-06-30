import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:justcost/data/city/city_repository.dart';
import 'package:justcost/data/city/model/country.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/login/login_screen.dart';
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
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{4,}))$';
  RegExp regex;
  final _formKey = GlobalKey<FormState>();
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();
  FocusNode _mailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();
  RegisterBloc _registerBloc;
  int genderGroupValue;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Country> _countries = [];
  List<City> _cities = [];
  Country _selectedCountry;
  City _selectedCity;
  String _countryCode;

  @override
  void initState() {
    super.initState();
    CityRepository repository = DependenciesProvider.provide();
    repository.getCountries().then((countriesData) {
      setState(() {
        this._countries = countriesData.data;
      });
    });
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
          children: <Widget>[
            Align(
              child: Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/icon/android/justcost-title.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Hero(
              tag: "form",
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
                  child: Column(
                    children: <Widget>[
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
                                    contentPadding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 8, bottom: 8),
                                    labelText: 'Full Name',
                                    errorMaxLines: 1,
                                    labelStyle:
                                        Theme.of(context).textTheme.body1,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(0)))),
                            SizedBox(
                              height: 4,
                            ),
                            TextFormField(
                              scrollPadding: EdgeInsets.all(0),
                              maxLines: 1,
                              focusNode: _usernameFocusNode,
                              validator: (username) {
                                return username.isEmpty
                                    ? AppLocalizations.of(context)
                                        .usernameFieldEmptyError
                                    : null;
                              },
                              controller: _userNameController,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(_mailFocusNode);
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 8, bottom: 8),
                                  labelStyle: Theme.of(context).textTheme.body1,
                                  hintText: AppLocalizations.of(context)
                                      .usernameFieldHint,
                                  prefixText: '@',
                                  labelText: AppLocalizations.of(context)
                                      .usernameFieldHint,
                                  errorMaxLines: 1,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0))),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            TextFormField(
                              controller: _emailController,
                              focusNode: _mailFocusNode,
                              maxLines: 1,
                              validator: (mail) {
                                if (mail.isEmpty)
                                  return AppLocalizations.of(context)
                                      .emailFieldEmptyError;
                                else if (!mail.contains('@'))
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
                                  labelStyle: Theme.of(context).textTheme.body1,
                                  contentPadding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 8, bottom: 8),
                                  hintText: AppLocalizations.of(context)
                                      .emailFieldHint,
                                  labelText: AppLocalizations.of(context)
                                      .emailFieldHint,
                                  errorMaxLines: 1,
                                  errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(0)),
                                      gapPadding: 0.0,
                                      borderSide: BorderSide(
                                          color: Theme.of(context).errorColor)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0))),
                            ),
                            const SizedBox(
                              height: 4,
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
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _attemptRegister();
                              },
                              maxLines: 1,
                              obscureText: true,
                              decoration: InputDecoration(
                                  errorMaxLines: 1,
                                  contentPadding: EdgeInsets.only(
                                      left: 16, right: 16, top: 8, bottom: 8),
                                  hintText: '**********',
                                  labelStyle: Theme.of(context).textTheme.body1,
                                  labelText: AppLocalizations.of(context)
                                      .passwordFieldHint,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0))),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            DropdownButtonFormField<Country>(
                              value: _selectedCountry,
                              hint: Text('Country'),
                              onChanged: (country) {
                                setState(() {
                                  _selectedCity=null;
                                  _countryCode=null;
                                  _selectedCountry = country;
                                  _cities = country.cities;
                                  _countryCode = country.code;
                                });
                              },
                              items: _countries
                                  .map((country) => DropdownMenuItem<Country>(
                                        child: Text(country.name),
                                        value: country,
                                      ))
                                  .toList(),
                              decoration: InputDecoration(
                                  labelStyle: Theme.of(context).textTheme.body1,
                                  contentPadding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 8, bottom: 8),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0))),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            DropdownButtonFormField<City>(
                              onChanged: (city) {
                                setState(() {
                                  this._selectedCity = city;
                                });
                              },
                              value: _selectedCity,
                              hint: Text('City'),
                              items: _cities
                                  .map((city) => DropdownMenuItem<City>(
                                        child: Text(city.name),
                                        value: city,
                                      ))
                                  .toList(),
                              decoration: InputDecoration(

                                  contentPadding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 8, bottom: 8),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0))),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            TextFormField(
                              focusNode: _phoneNumberFocusNode,
                              maxLines: 1,
                              textInputAction: TextInputAction.next,
                              validator: (phone) {
                                return phone.isEmpty
                                    ? AppLocalizations.of(context)
                                        .phoneNumberEmptyError
                                    : null;
                              },
                              keyboardType: TextInputType.phone,
                              controller: _phoneNumberController,
                              onEditingComplete: () {},
                              decoration: InputDecoration(
                                  labelStyle: Theme.of(context).textTheme.body1,
                                  contentPadding: EdgeInsets.only(
                                      left: 16, right: 16, top: 8, bottom: 8),
                                  hintText: '00-000-0000',
                                  labelText: AppLocalizations.of(context)
                                      .phoneNumberField,
                                  prefixText: '+$_countryCode',
                                  errorMaxLines: 1,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0))),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            DropdownButtonFormField(
                              value: genderGroupValue,
                              hint: Text('Gender'),
                              onChanged: (gender) {
                                setState(() {
                                  this.genderGroupValue = gender;
                                });
                              },
                              items: [
                                DropdownMenuItem(
                                  child: Text('Male',
                                      style: Theme.of(context).textTheme.body1),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text('Female',
                                      style: Theme.of(context).textTheme.body1),
                                  value: 0,
                                ),
                              ],
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 8, bottom: 8),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0))),
                            ),
                          ],
                        ),
                        key: _formKey,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: RaisedButton(
                            textTheme: ButtonTextTheme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            onPressed: _attemptRegister,
                            child: Text("Register"),
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(
                TextSpan(text: 'Already Have an Account? ', children: [
                  TextSpan(
                      text: 'Login',
                      style: TextStyle(color: Colors.lightBlue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                        })
                ]),
                textAlign: TextAlign.center,
              ),
            )
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
          city: _selectedCity.id,
          country:_selectedCountry,
          phoneNumber: _phoneNumberController.text.trim()));
    }
  }
}
