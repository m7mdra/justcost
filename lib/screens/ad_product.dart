import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:justcost/data/attribute/model/category_attribute.dart';
import 'package:justcost/data/brand/model/brand.dart';
import 'package:justcost/data/category/model/category.dart';
import 'package:justcost/data/city/model/country.dart';
import 'package:justcost/model/media.dart';

class Ad {
  String title;
  String keyword;
  String description;
  Country country;
  City city;
  LatLng location;
  String phoneNumber;
  String email;
  String facebookPage;
  String instagramPage;
  List<Media> mediaList;
  List<AdProduct> adProducts;

  Ad(
      {this.title,
      this.keyword,
      this.description,
      this.country,
      this.city,
      this.location,
      this.phoneNumber,
      this.email,
      this.facebookPage,
      this.instagramPage,
      this.mediaList,
      this.adProducts});

  @override
  String toString() {
    return 'Ad{title: $title, keyword: $keyword, description: $description, country: $country, city: $city, location: $location, phoneNumber: $phoneNumber, email: $email, facebookPage: $facebookPage, instagramPage: $instagramPage, mediaList: $mediaList, adProducts: $adProducts}';
  }
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
