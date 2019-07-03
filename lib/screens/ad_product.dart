import 'package:justcost/data/brand/model/brand.dart';
import 'package:justcost/data/category/model/category.dart';

class AdProduct {
  final String name;
  final String quantity;
  final String oldPrice;
  final String newPrice;
  final Category category;
  final Brand brand;
  final String details;

  AdProduct(
      {this.name,
      this.quantity,
      this.oldPrice,
      this.newPrice,
      this.category,
      this.brand,
      this.details});
}
