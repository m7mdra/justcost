import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.cloud,
            size: 80,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'No Data Found at this moment',
          ),
        ],
      ),
    );
  }
}
