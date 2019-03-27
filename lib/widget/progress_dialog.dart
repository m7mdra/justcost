import 'package:flutter/material.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';

class ProgressDialog extends StatelessWidget {
  final String title;

  const ProgressDialog({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(
            strokeWidth: 1,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Please wait while loging in...',
            style: Theme.of(context).textTheme.body1,
          )
        ],
      ),
    );
  }
}
