import 'package:justcost/data/city/model/country.dart';

class User {
  int id;
  String email;
  String username;
  String name;
  String mobile;
  Country country;
  City city;
  int gender;
  String image;
  bool isVerified;
  String firebaseToken;

  User(
      {this.id,
        this.email,
        this.username,
        this.name,
        this.mobile,
        this.country,
        this.city,
        this.gender,
        this.image,
        this.isVerified,
        this.firebaseToken});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    name = json['name'];
    mobile = json['mobile'];
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    gender = json['gender'];
    image = json['image'];
    isVerified = json['isVerified'];
    firebaseToken = json['firebaseToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    if (this.country != null) {
      data['country'] = this.country.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    data['gender'] = this.gender;
    data['image'] = this.image;
    data['isVerified'] = this.isVerified;
    data['firebaseToken'] = this.firebaseToken;
    return data;
  }
}
