import 'package:flutter/material.dart';
import 'package:justcost/screens/home/main_screen.dart';
import 'package:justcost/screens/register/register_screen.dart';
import 'package:justcost/screens/reset_password/reset_password_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
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
                'Login',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              minLines: 1,
              decoration: InputDecoration(
                  hintText: 'Username',
                  labelText: 'Username',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              obscureText: true,
              minLines: 1,
              decoration: InputDecoration(
                  hintText: '**********',
                  labelText: 'Password',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MaterialButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen()));
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              onPressed: () {},
              child: Text('Login'),
              color: Theme.of(context).accentColor,
            ),
            const Divider(),
            OutlineButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MainScreen()));
              },
              child: Text('Continue as guest'),
            ),
            OutlineButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RegisterScreen()));
              },
              child: Text('Register'),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'About us',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                Text(' | '),
                Text(
                  'Get Help',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Center(child: Text('Version 1.0')),
            const SizedBox(
              height: 2,
            ),
            Center(child: Text('Copyright © 2019, All Rights resereved.')),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Privacy',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                Text(' | '),
                Text(
                  'Terms of Service',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
