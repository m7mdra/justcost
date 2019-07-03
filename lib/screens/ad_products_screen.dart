import 'package:flutter/material.dart';
import 'package:justcost/data/brand/model/brand.dart';
import 'package:justcost/data/category/model/category.dart';

import 'ad_product.dart';
import 'add_ad_product_screen.dart';

enum AdditionType { single, multiple }

class AdProductsScreen extends StatefulWidget {
  final AdditionType additionType;

  const AdProductsScreen({Key key, this.additionType = AdditionType.single})
      : super(key: key);

  @override
  _AdProductsScreenState createState() => _AdProductsScreenState();
}

class _AdProductsScreenState extends State<AdProductsScreen> {
  List<AdProduct> adProducts = <AdProduct>[
    AdProduct(
        name:
            "ASUS ZenBook Pro UX501VW 15.6\" 4K TouchScreen UltraBook: Intel Quad Core i7-6700HQ | 512GB NVMe SSD | 16 DDR4 | NVIDIA GTX 960M 4GB | IPS UHD (3840x2160) | Thunderbolt III | Windows 10 Professional",
        quantity: '1',
        newPrice: "60",
        oldPrice: '80',
        category: Category(name: 'laptops'),
        brand: Brand(name: 'ASUS'),
        details:
            """15.6" TouchScreen IPS 4K Ultra­-HD display, 3840 x 2160 resolution
Intel Skylake Quad-Core i7­-6700HQ 2.6 GHz CPU (turbo to 3.5GHz) | Dedicated Nvidia GTX 960M 4GB GDDR5 Graphics
512GB NVMe SSD with transfer speeds of 1400MB/s | 16 GB DDR4 2133 MHz
1x Thunderbolt III (via USB Type­C), 1x Gen 2 USB 3.1 Type­C, 3x USB 3.0, 1x HDMI.Bluetooth 4.0, SDXC reader, 802.11ac Wi­Fi
Windows 10 Professional 64-bit | 1­ year Warranty with Accidental Damage Protection""")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ad products'),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                if (widget.additionType == AdditionType.single &&
                    adProducts.length == 1) return;
                var adProduct = await Navigator.push(
                    context,
                    MaterialPageRoute<AdProduct>(
                        builder: (context) => AddAdProductScreen()));
                if (adProduct != null) {
                  setState(() {
                    adProducts.add(adProduct);
                  });
                }
              },
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: adProducts.isEmpty
            ? Center(
                child: Text(
                  'No product added\n Tap on ➕ icon to add product',
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Column(
                      children: <Widget>[
                        Text(
                          "${adProducts[index].oldPrice} AED",
                          style:
                              TextStyle(decoration: TextDecoration.lineThrough),
                        ),
                        Text(
                          "${adProducts[index].newPrice} AED",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red,fontSize: 16),
                        )
                      ],
                    ),
                    title: Text(
                      adProducts[index].name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(adProducts[index].details,
                        maxLines: 3, overflow: TextOverflow.ellipsis),
                  );
                },
                itemCount: adProducts.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 1,
                  );
                },
              ));
  }
}
