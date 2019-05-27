import 'package:flutter/material.dart';
import 'package:justcost/data/product/model/product.dart';

class AdWidget extends StatelessWidget {
  final VoidCallback onTap;
  final Product product;

  const AdWidget({Key key, this.onTap, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Row(
          children: <Widget>[
            Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
               Image.network(product.media[0].url,height: 100,width: 100,),
                Container(
                  color: Colors.yellow,
                  child: Text(
                      '${((product.regPrice - product.salePrice) / product.regPrice * 100).round()}% OFF'),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(product.title == null ? '' : product.title,
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            .copyWith(color: Colors.black)),
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
                      product.postedOn,
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
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () {},
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
