import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
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
                'Registeration',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: 'Username',
                  labelText: 'Username',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: 'E-mail address',
                  labelText: 'mail@domain.com',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: '**********',
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: '**********',
                  labelText: 'Confirm password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              onPressed: () {},
              child: Text('Register'),
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
      ),
    );
  }
}
