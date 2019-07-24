import 'package:flutter/material.dart';
import 'package:justcost/i10n/app_localizations.dart';
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NetworkErrorWidget({Key key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.cloud_off,
              size: 80,
            ),
            Text(
              AppLocalizations.of(context).noInternetConnectionTitle,
              style: Theme.of(context).textTheme.title,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              AppLocalizations.of(context).noInternetConnectionMessage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8,
            ),
            OutlineButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context).tryAgainButton),
            )
          ],
        ),
      ),
    );
  }
}
