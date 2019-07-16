import 'dart:async';

import 'package:flutter/material.dart';
import 'package:justcost/screens/register/register_screen.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<TextSpan> spans = [
    TextSpan(text: '  ', children: [TextSpan(text: '        ')]),
    TextSpan(
        text: ' 6',
        style: TextStyle(fontWeight: FontWeight.bold),
        children: [
          TextSpan(
              text: ' Countries',
              style:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        ]),
    TextSpan(
        text: ' 60',
        style: TextStyle(fontWeight: FontWeight.bold),
        children: [
          TextSpan(
              text: ' Cities',
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold)),
        ]),
    TextSpan(
        text: ' 21',
        style: TextStyle(fontWeight: FontWeight.bold),
        children: [
          TextSpan(
              text: ' Offers',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ]),
  ];
  List<double> percentages = [0.0, 0.3, 0.7, 1.0];
  int _currentIndex = 0;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentIndex < 3) {
        setState(() {
          _currentIndex += 1;
        });
      } else {
        timer.cancel();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RegisterScreen()));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withAlpha(50)),
                          shape: BoxShape.circle),
                    ),
                    Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'assets/icon/android/justcost-title.png',
                        width: 150,
                        height: 150,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Welcome to you',
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Enjoy the hot sales over the'),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: Text.rich(
                    spans[_currentIndex],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.body1,
                    key: ValueKey(_currentIndex),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LinearProgressIndicator(
                value: percentages[_currentIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
