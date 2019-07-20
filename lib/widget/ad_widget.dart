import 'package:flutter/material.dart';
import 'package:justcost/data/product/model/product.dart';

import 'discount_badge_widget.dart';

class AdWidget extends StatelessWidget {
  final VoidCallback onTap;
  final Product product;

  const AdWidget({Key key, this.onTap, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: <Widget>[
            Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                ClipRRect(
                  child: Image.network(
                    product.media[0].url,
                    height: 120,
                    width: 120,
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                ),
                DiscountPercentageBannerWidget(
                  regularPrice: product.regPrice,
                  salePrice: product.salePrice,
                  onLike: () {},
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.title == null ? '' : product.title,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: Colors.black),
                      maxLines: 2,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      product.city,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: Colors.black),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${product.postedOn}",
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: Colors.black),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    '${product.salePrice} AED',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w900,
                        fontSize: 16),
                  ),
                  /*Container(
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.white,

                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(8)),
                  ),*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
