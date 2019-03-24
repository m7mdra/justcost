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
              height: 16,
            ),
            Align(
              child: ClipOval(
                child: Image.network(
                  'https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_960_720.png',
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              child: OutlineButton(
                child: Text('Select Profile Avatar'),
                onPressed: () {},
              ),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
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
                  contentPadding: EdgeInsets.all(10),
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
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Address',
                  labelText: 'Address',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: '000-0000-0000',
                  labelText: 'Phone Number',
                  prefixText: '+',
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
                  contentPadding: EdgeInsets.all(10),
                  hintText: '**********',
                  labelText: 'Password',
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
