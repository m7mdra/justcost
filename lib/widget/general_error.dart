import 'package:flutter/material.dart';
import 'package:justcost/i10n/app_localizations.dart';
class GeneralErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const GeneralErrorWidget({Key key, this.onRetry}) : super(key: key);

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
              Icons.error,
              size: 80,
            ),
            Text(
              AppLocalizations.of(context).generalError,
              style: Theme.of(context).textTheme.title,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              AppLocalizations.of(context).contactSupportTryAgain,
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
