import 'package:flutter/material.dart';
import 'package:justcost/model/media.dart';
import 'package:justcost/screens/ad.dart';
import 'package:justcost/screens/ad_contact_screen.dart';
import 'package:justcost/screens/ad_details_screen.dart';
import 'package:justcost/screens/ad_products_screen.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';

class AdTypeSelectScreen extends StatefulWidget {
  final AdDetails adDetails;
  final AdContact adContact;

  const AdTypeSelectScreen(
      {Key key, this.adDetails, this.adContact})
      : super(key: key);

  @override
  _AdTypeSelectScreenState createState() => _AdTypeSelectScreenState();
}

class _AdTypeSelectScreenState extends State<AdTypeSelectScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Ad Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WillPopScope(
          onWillPop: () async {
            bool dismiss = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => RoundedAlertDialog(
                      title: Text('Discard data?'),
                      content: Text('Are you sure?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Yes'),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                        FlatButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                        ),
                      ],
                    ));
            return Future.value(dismiss);
          },
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
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => AdProductsScreen(
                            additionType: AdditionType.single,
                            adDetails: widget.adDetails,
                            adContact: widget.adContact,
                          )));
                },
              ),
              Divider(
                height: 0,
              ),
              ListTile(
                title: Text('Wholesale'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => AdProductsScreen(
                            additionType: AdditionType.multiple,
                            adDetails: widget.adDetails,
                            adContact: widget.adContact,
                          )));
                },
              ),
              Divider(
                height: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
