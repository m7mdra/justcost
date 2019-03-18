import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.https,
              size: 50,
            ),
            Text(
              'Type your e-mail address and will send you a mail'
                  ' containing the instructions to reset your password',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'mail@domain.com',
                  labelText: 'E-mail address',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              onPressed: () {},
              child: Text('Submit'),
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
      ),
    );
  }
}
