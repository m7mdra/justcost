import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:pinput/pin_put/pin_put_bloc.dart';
import 'package:pinput/pin_put/pin_put_state.dart';

import 'reset_account_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  ResetAccountBloc _bloc;
  GlobalKey<FormState> _formKey;
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex;
  TextEditingController _phoneNumberTextController;
  TextEditingController _emailTextController;
  TextEditingController _resetCodeTextController;
  TextEditingController _codeTextController;
  TextEditingController _newPasswordTextController;

  var selectedState = 1;

  var backPress = 0;
  Future<bool> _onWillPop() {
    var result = showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){}
    );

    result.then((value){backPress = value;});
    return result ?? false;
  }

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(myInterceptor);


    _phoneNumberTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _resetCodeTextController = TextEditingController();
    _codeTextController = TextEditingController();
    _newPasswordTextController = TextEditingController();

    _formKey = GlobalKey<FormState>();
    _bloc = ResetAccountBloc(DependenciesProvider.provide());
    _bloc.state.listen((state) {
      if (state is ResetErrorState) {
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
    });
    regex = new RegExp(pattern);
  }

  @override
  void dispose() {
    super.dispose();
    BackButtonInterceptor.remove(myInterceptor);
    _bloc.dispose();
    _phoneNumberTextController.dispose();
    _emailTextController.dispose();
    _resetCodeTextController.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    _bloc = ResetAccountBloc(DependenciesProvider.provide());
    print("BACK BUTTON!");
    if(selectedState == 1){
      Navigator.pop(context);
    }
    else if(selectedState == 2){
      print('backed  $selectedState');
      setState(() {
        selectedState--;
      });
    }
    else if(selectedState == 3){
      setState(() {
        selectedState--;
      });
    }
    else if(selectedState == 4){
      setState(() {
        selectedState--;
      });
    }
//    backPress++;// Do some stuff.
//    if(backPress == 2){
//      _onWillPop();
//    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder(
            bloc: _bloc,
            builder: (context, state) {

              if (state is ResetLoadingState)
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(child: CircularProgressIndicator()),
                  ],
                );

              if (state is PhoneNumberResetSelectedState)
                return buildPhoneNumberResetState(context);

              if (state is EmailResetSelectedState)
                return buildEmailResetState(context);

              if(state is ResetSuccessState){
                return buildPhoneCodeForm(context,state.phone);
              }

              if(state is SendCodeSuccessState) {
                return buildNewPassword(context,state.token);
              }

              if(state is PasswordChangedSuccess) {
                return SuccessfullyChangePassword(context);
              }

              if(state is ResetEmailSuccessState) {
                return SendResetEmail(context);
              }

              return selectedState == 1 ? buildSelectState() : selectedState == 2 ? buildPhoneNumberResetState(context) : selectedState == 3 ? buildEmailResetState(context) : Container();
            },
          ),
        ),
      ),
    );
  }

  Column buildPhoneCodeForm(BuildContext context,String phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.sms,
          size: 60,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          AppLocalizations.of(context).resetSuccessTitle,
          style: Theme.of(context).textTheme.title,
        ),
        SizedBox(
          height: 8,
        ),
        Text.rich(
          TextSpan(children: [
            TextSpan(
              text: AppLocalizations.of(context).weSentMessageTo,
            ),
            TextSpan(
                text: '+$phone',
                style: TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.w700)),
            TextSpan(text: ' ${AppLocalizations.of(context).containing} '),
            TextSpan(
                text: '6',
                style: TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.w700)),
            TextSpan(text: AppLocalizations.of(context).fiveDigitCode)
          ]),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body1,
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 64, right: 64),
          child: Container(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                controller: _codeTextController,
                maxLength: 6,
                maxLines: 1,
                maxLengthEnforced: true,
                autofocus: true,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(border: OutlineInputBorder()),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),

        RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () {
            var code = _codeTextController.text;
            if (code.length > 5) _bloc.dispatch(SendCodeEvent(code,phone));
          },
          child: Text(AppLocalizations.of(context).submitButton),
          color: Theme.of(context).accentColor,
        ),

      ],
    );
  }

  Column buildNewPassword(BuildContext context,String token) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.lock,
          size: 60,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          AppLocalizations.of(context).changePassword,
          style: Theme.of(context).textTheme.title,
        ),
        SizedBox(
          height: 8,
        ),
        Text.rich(
          TextSpan(children: [
            TextSpan(
              text: AppLocalizations.of(context).changePasswordSubtitle,
            ),
          ]),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body1,
        ),
        SizedBox(
          height: 8,
        ),
        Text.rich(
          TextSpan(children: [
            TextSpan(
              text: 'قم بادخال كلمة المرور الجديده',
            ),
          ]),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body1,
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 34, right: 34),
          child: Container(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                controller: _newPasswordTextController,
                maxLines: 1,
                maxLengthEnforced: true,
                autofocus: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(border: OutlineInputBorder()),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () {
            var form = _formKey.currentState;
            var password = _newPasswordTextController.text;
            if (password.length > 0) _bloc.dispatch(InsertNewPassword(password: password,token: token));
          },
          child: Text(AppLocalizations.of(context).submitButton),
          color: Theme.of(context).accentColor,
        ),

      ],
    );
  }

  Column SuccessfullyChangePassword(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.check,
          size: 60,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context).passwordChangedSuccessfully,
          style: Theme.of(context).textTheme.title,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 16,
        ),

        RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(NavigationReason.password_change)));
          },
          child: Text(AppLocalizations.of(context).loginScreenName),
          color: Theme.of(context).accentColor,
        ),

      ],
    );
  }

  Column SendResetEmail(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.check,
          size: 60,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'تم ارسال رسالة نصية قصيرة الي ايميلك تحتوي علي رابط لاستعادة كلمة المرور',
          style: Theme.of(context).textTheme.title,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 16,
        ),

        RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(NavigationReason.none)));
          },
          child: Text('الرجوع الي تسجيل الدخول'),
          color: Theme.of(context).accentColor,
        ),

      ],
    );
  }

  Column buildEmailForm(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(
          Icons.sms,
          size: 60,
        ),
        Text(
          AppLocalizations.of(context).resetSuccessTitle,
          style: Theme.of(context).textTheme.title,
        ),
        SizedBox(
          height: 8,
        ),
        Text.rich(
          TextSpan(children: [
            TextSpan(
              text: AppLocalizations.of(context).weSentMessageTo,
            ),
            TextSpan(
                text: 'Mail@domain.com',
                style: TextStyle(decoration: TextDecoration.underline)),
            TextSpan(text: ' ${AppLocalizations.of(context).containing} '),
            TextSpan(
                text: '5',
                style: TextStyle(decoration: TextDecoration.underline)),
            TextSpan(text: ' ${AppLocalizations.of(context).fiveDigitCode}')
          ]),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body1,
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 64, right: 64),
          child: TextField(
            maxLength: 5,
            maxLines: 1,
            maxLengthEnforced: true,
            autofocus: true,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        OutlineButton(
          onPressed: () {},
          child: Text(AppLocalizations.of(context).submitButton),
        )
      ],
    );
  }

  Widget buildSelectState() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.account_circle,
            size: 80,
          ),
          Text(
            AppLocalizations.of(context).resetAccount,
            style: Theme.of(context).textTheme.title,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            AppLocalizations.of(context).resetInstructions,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.body2,
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      selectedState++;
                      print('phoneNumber  $selectedState');
                    });
                    _bloc.dispatch(PhoneNumberResetSelected());
                  },
                  child:
                      Text(AppLocalizations.of(context).usePhoneNumberOption),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    selectedState++;
                    print('email  $selectedState');
                    _bloc.dispatch(EmailResetSelected());
                  },
                  child: Text(AppLocalizations.of(context).useEmailOption),
                  textColor: Colors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildPhoneNumberResetState(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.phonelink_lock,
          size: 80,
        ),
        Text(AppLocalizations.of(context).resetAccount,
            style: Theme.of(context).textTheme.title),
        Text(
          AppLocalizations.of(context).phoneNumberResetInstruction,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 16,
        ),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _phoneNumberTextController,
            validator: (mail) {
              if (mail.isEmpty)
                return AppLocalizations.of(context).phoneNumberEmptyError;
              else
                return null;
            },
            maxLines: 1,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                prefixText: '+',
                hintText: '0000-0000-000',
                labelText: AppLocalizations.of(context).phoneNumberField,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5))),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () {
            var form = _formKey.currentState;
            var phone = _phoneNumberTextController.text;
            if (form.validate()) _bloc.dispatch(SubmitPhoneNumber(phone));
          },
          child: Text(AppLocalizations.of(context).submitButton),
          color: Theme.of(context).accentColor,
        ),
      ],
    );
  }

  Widget buildEmailResetState(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.phonelink_lock,
          size: 80,
        ),
        Text(AppLocalizations.of(context).resetAccount,
            style: Theme.of(context).textTheme.title),
        Text(
          AppLocalizations.of(context).emailResetInstruction,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 16,
        ),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _emailTextController,
            validator: (mail) {
              if (mail.isEmpty)
                return AppLocalizations.of(context).emailFieldEmptyError;
              if (!regex.hasMatch(mail))
                return AppLocalizations.of(context).emailFieldInvalidError;
              else
                return null;
            },
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hintText: 'mail@domain.com',
                labelText: AppLocalizations.of(context).emailFieldLabel,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16))),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () {
            var form = _formKey.currentState;
            var email = _emailTextController.text;
            if (form.validate()) _bloc.dispatch(SubmitEmailEvent(email));
          },
          child: Text(AppLocalizations.of(context).submitButton),
          color: Theme.of(context).accentColor,
        ),
      ],
    );
  }
}
