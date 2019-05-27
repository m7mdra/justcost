import 'package:flutter/material.dart';

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
              'No Internet Connection',
              style: Theme.of(context).textTheme.title,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'No internet connection found, check your connection or tap on Try again',
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
