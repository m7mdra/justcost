import 'package:flutter/material.dart';
import 'package:justcost/i10n/app_localizations.dart';

class DiscountPercentageBannerWidget extends StatelessWidget {
  final int regularPrice;
  final int salePrice;
  final bool liked;
  final VoidCallback onLike;

  const DiscountPercentageBannerWidget(
      {Key key, this.regularPrice, this.salePrice, this.liked, this.onLike})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      highlightColor: Theme.of(context).primaryColor,
      splashColor: Theme.of(context).primaryColor,
      onTap: () {},
      child: Container(
          color: Colors.yellow,
          child: Text(
            AppLocalizations.of(context).discountPercentage(
                ((regularPrice - salePrice) / regularPrice * 100).round()),
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
    );
  }
}
