import 'package:flutter/material.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/postad/ad.dart';
import 'package:justcost/model/media.dart';
import 'ad_image_view.dart';
import 'ad_video_view.dart';

class ProductDismissibleWidget extends StatelessWidget {
  const ProductDismissibleWidget({
    Key key,
    @required this.adProduct,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  final AdProduct adProduct;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        child: Dismissible(
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) onDelete();
          },
          background: Container(
            color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.delete_forever),
                ),
              ],
            ),
          ),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Column(
                  children: <Widget>[
                    Text(
                      "${adProduct.oldPrice} AED",
                      style: TextStyle(decoration: TextDecoration.lineThrough),
                    ),
                    Text(
                      "${adProduct.newPrice} AED",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 16),
                    )
                  ],
                ),
                title: Text(
                  adProduct.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(adProduct.details,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: OutlineButton.icon(
                    onPressed: () {
                      onEdit();
                    },
                    icon: Icon(Icons.edit),
                    label: Text(AppLocalizations.of(context).editButton)),
              ),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: adProduct.mediaList.length,
                  padding: const EdgeInsets.all(8),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    if (adProduct.mediaList[index].type == Type.Image)
                      return AdImageView(
                        showRemoveIcon: false,
                        file: adProduct.mediaList[index].file,
                        size: Size(150, 150),
                      );
                    else
                      return AdVideoView(
                        file: adProduct.mediaList[index].file,
                        showRemoveIcon: false,
                        size: Size(150, 150),
                      );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return VerticalDivider();
                  },
                ),
              ),
            ],
          ),
          key: ObjectKey(adProduct.hashCode),
        ),
      ),
    );
  }
}