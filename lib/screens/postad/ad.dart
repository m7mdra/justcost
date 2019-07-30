import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:justcost/data/attribute/model/category_attribute.dart';
import 'package:justcost/data/brand/model/brand.dart';
import 'package:justcost/data/category/model/category.dart';
import 'package:justcost/data/city/model/country.dart';
import 'package:justcost/model/media.dart';


class Ad {
  AdDetails adDetails;
  AdContact adContact;
  List<AdProduct> adProducts;
  bool isWholeSale;

  Ad({this.adContact, this.adProducts, this.adDetails, this.isWholeSale});

  Map<String, dynamic> toJson() => {
        "isWholeSale": isWholeSale,
        "adDetails": adDetails.toJson(),
        "adContact": adContact.toJson(),
        "adProducts": adProducts.map((product) => product.toJson()).toList()
      };

}

class AdProduct {
  String name;
  String quantity = "0";
  String oldPrice;
  String newPrice;
  Category category;
  Brand brand;
  List<Media> mediaList;
  String keyword;
  String details;
  List<Attribute> attributes;

  AdProduct(
      {this.name,
      this.keyword,
      this.mediaList,
      this.quantity = "0",
      this.oldPrice,
      this.newPrice,
      this.category,
      this.brand,
      this.details,
      this.attributes});

  @override
  String toString() {
    return 'AdProduct{name: $name, quantity: $quantity, oldPrice: $oldPrice, newPrice: $newPrice, category: $category, brand: $brand, mediaList: $mediaList, details: $details, attributes: $attributes}';
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
        "oldPrice": oldPrice,
        "newPrice": newPrice,
        "category": category.toJson(),
        "brand": "",
        "media": mediaList.map((media) => media.toJson()).toList()
      };
}

class AdDetails {
  final String title, description;

  AdDetails({this.title, this.description});

  @override
  String toString() {
    return 'AdDetails{title: $title, description: $description}';
  }

  Map<String, dynamic> toJson() => {"title": title, "description": description};
}

class AdContact {
  Country country;
  City city;
  LatLng location;
  String phoneNumber;
  String email;
  String facebookPage;
  String instagramPage;

  AdContact(
      {this.phoneNumber,
      this.location,
      this.city,
      this.country,
      this.email,
      this.facebookPage,
      this.instagramPage});

  @override
  String toString() {
    return 'AdContact{country: $country, city: $city, location: $location, phoneNumber: $phoneNumber, email: $email, facebookPage: $facebookPage, instagramPage: $instagramPage}';
  }

  Map<String, dynamic> toJson() => {
        "country": country.toJson(),
        "city": city.toJson(),
        "location": "${location.latitude},${location.longitude}",
        "phoneNumber": phoneNumber,
        "email": email,
        "facebookPage": facebookPage,
        "instagramPage": instagramPage,
      };
}
