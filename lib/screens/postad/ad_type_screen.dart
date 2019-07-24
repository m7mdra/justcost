import 'package:flutter/material.dart';
import 'package:justcost/screens/postad/ad.dart';
import 'package:justcost/screens/postad/ad_products_screen.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';
import 'package:justcost/i10n/app_localizations.dart';

class AdTypeSelectScreen extends StatefulWidget {
  final AdDetails adDetails;
  final AdContact adContact;

  const AdTypeSelectScreen({Key key, this.adDetails, this.adContact})
      : super(key: key);

  @override
  _AdTypeSelectScreenState createState() => _AdTypeSelectScreenState();
}

class _AdTypeSelectScreenState extends State<AdTypeSelectScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).selectAdType),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WillPopScope(
          onWillPop: () async {
            bool dismiss = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => RoundedAlertDialog(
                      title: Text(AppLocalizations.of(context).discardData),
                      content: Text(AppLocalizations.of(context).areYouSure),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                              MaterialLocalizations.of(context).okButtonLabel),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                        FlatButton(
                          child: Text(MaterialLocalizations.of(context)
                              .cancelButtonLabel),
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
                TextSpan(
                    text: "${AppLocalizations.of(context).select} ",
                    children: [
                      TextSpan(
                          text: AppLocalizations.of(context).normalAd,
                          style: Theme.of(context).textTheme.body1.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 16)),
                      TextSpan(
                          text:
                              ' ${AppLocalizations.of(context).normalAdExplain}'),
                      TextSpan(text: '\n'),
                      TextSpan(text: "${AppLocalizations.of(context).select} "),
                      TextSpan(
                          text: AppLocalizations.of(context).wholesaleAd,
                          style: Theme.of(context).textTheme.body1.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 16)),
                      TextSpan(
                          text:
                              ' ${AppLocalizations.of(context).wholesaleAdExplain}'),
                    ]),
              ),
              SizedBox(
                height: 16,
              ),

              Card(
                child: ListTile(
                  title: Text(AppLocalizations.of(context).normalAd),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => AdProductsScreen(
                              additionType: AdditionType.single,
                              adDetails: widget.adDetails,
                              adContact: widget.adContact,
                            )));
                  },
                ),
              ),

              Card(
                child: ListTile(
                  title: Text(AppLocalizations.of(context).wholesaleAd),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => AdProductsScreen(
                              additionType: AdditionType.multiple,
                              adDetails: widget.adDetails,
                              adContact: widget.adContact,
                            )));
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
