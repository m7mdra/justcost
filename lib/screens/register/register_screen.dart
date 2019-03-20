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
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),

                  hintText: 'Username',
                  labelText: 'Username',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),

                  hintText: 'mail@domain.com',
                  labelText: 'E-mail address',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              maxLines: 1,
              obscureText: true,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  hintText: '**********',
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              maxLines: 1,
              obscureText: true,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),

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
              color: Theme
                  .of(context)
                  .accentColor,
            ),
          ],
        ),
      ),
    );
  }
}
