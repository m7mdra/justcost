import 'package:flutter/material.dart';
import 'package:justcost/i10n/app_localizations.dart';

class NoDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.cloud,
              size: 50,
            ),
            Text(
              AppLocalizations.of(context).noDataFoundAtThisMoment,
              style: Theme.of(context).textTheme.subhead,
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
