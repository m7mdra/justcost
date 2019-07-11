import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:justcost/data/attribute/model/category_attribute.dart';
import 'package:justcost/data/brand/model/brand.dart';
import 'package:justcost/data/category/model/category.dart';
import 'package:justcost/data/city/model/country.dart';
import 'package:justcost/model/media.dart';

import 'ad_contact_screen.dart';
import 'ad_details_screen.dart';

class Ad {
  AdDetails adDetails;
  AdContact adContact;
  List<Media> mediaList;
  List<AdProduct> adProducts;

  Ad({this.adContact, this.mediaList, this.adProducts, this.adDetails});
}


class AdProduct {
  String name;
  String quantity;
  String oldPrice;
  String newPrice;
  Category category;
  Brand brand;
  String details;
  List<Attribute> attributes;

  AdProduct(
      {this.name,
      this.quantity,
      this.oldPrice,
      this.newPrice,
      this.category,
      this.brand,
      this.details,
      this.attributes});

  @override
  String toString() {
    return 'AdProduct{name: $name, quantity: $quantity, oldPrice: $oldPrice, newPrice: $newPrice, category: $category, brand: $brand, details: $details}';
  }
}
