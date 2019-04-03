import 'package:flutter/material.dart';
import 'account_verification_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/main.dart';

class AccountVerificationScreen extends StatefulWidget {
  @override
  _AccountVerificationScreenState createState() =>
      _AccountVerificationScreenState();
}

class _AccountVerificationScreenState extends State<AccountVerificationScreen> {
  AccountVerificationBloc _accountVerificationBloc;

  @override
  void initState() {
    super.initState();
    _accountVerificationBloc = AccountVerificationBloc(getIt.get());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder(
          bloc: _accountVerificationBloc,
          builder: (BuildContext context, VerificationState state) {
            if (state is VerificationIdle)
              return buildIdleState(context, false);
            else if (state is VerificationLoading)
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            else if (state is VerificationError)
              return buildIdleState(context, true);
            else if (state is VerificationSuccess)
              return buildSuccessState(context);
          },
        ),
      ),
    );
  }

  Column buildIdleState(BuildContext context, bool error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Icon(
          Icons.verified_user,
          size: 80,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Account Verficiation is required.',
          style: Theme.of(context).textTheme.title,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'An E-mail address was sent to your account  containg instruction to verify you account',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body1,
        ),
        const SizedBox(
          height: 8,
        ),
        Text('Didnt receive email?'),
        const SizedBox(
          height: 8,
        ),
        error
            ? Text(
                'Failed to Send Verification Email, try again',
                style: TextStyle(color: Theme.of(context).errorColor),
              )
            : Container(),
        OutlineButton(
          child: Text('Resend'),
          onPressed: () {
            _accountVerificationBloc.dispatch(ResendVerification());
          },
          splashColor: Theme.of(context).accentColor,
        ),
      ],
    );
  }

  Column buildSuccessState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 80,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Account Verficiation is Send Successfully.',
          style: Theme.of(context).textTheme.title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'An E-mail address was sent to your account  containg instruction to verify you account',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body1,
        ),
        const SizedBox(
          height: 8,
        ),
        Text('Didnt receive email?'),
        const SizedBox(
          height: 8,
        ),
        FlatButton(
          child: Text('Contact support team'),
          onPressed: () {},
          splashColor: Theme.of(context).accentColor,
        ),
      ],
    );
  }
}
