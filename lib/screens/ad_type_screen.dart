import 'package:flutter/material.dart';
import 'package:justcost/screens/ad_products_screen.dart';

class AdTypeSelectScreen extends StatefulWidget {
  @override
  _AdTypeSelectScreenState createState() => _AdTypeSelectScreenState();
}

class _AdTypeSelectScreenState extends State<AdTypeSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Ad Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text.rich(
              TextSpan(text: "Select ", children: [
                TextSpan(
                    text: 'Normal',
                    style: Theme.of(context).textTheme.body1.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 16)),
                TextSpan(
                    text:
                        ' if you have only one single product you want to offer.'),
                TextSpan(text: '\n'),
                TextSpan(text: 'Select '),
                TextSpan(
                    text: 'Wholesale',
                    style: Theme.of(context).textTheme.body1.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 16)),
                TextSpan(
                    text:
                        ' if you have more than one product you want to offer.'),
              ]),
            ),
            SizedBox(
              height: 16,
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              title: Text('Normal'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdProductsScreen(
                          additionType: AdditionType.single,
                        )));
              },
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              title: Text('Wholesale'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdProductsScreen(
                          additionType: AdditionType.multiple,
                        )));
              },
            ),
            Divider(
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}
