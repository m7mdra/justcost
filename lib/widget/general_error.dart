import 'package:flutter/material.dart';

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
              'Unknown Error occured',
              style: Theme.of(context).textTheme.title,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'try again or contact support.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8,
            ),
            OutlineButton(
              onPressed: onRetry,
              child: Text('Try again'),
            )
          ],
        ),
      ),
    );
  }
}
