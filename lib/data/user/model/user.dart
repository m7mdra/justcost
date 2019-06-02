import 'package:justcost/data/city/model/city.dart';

class User {
  int id;
  String email;
  String username;
  String name;
  String mobile;
  int city;
  String image;
  int gender;
  bool isVerified;
  String firebaseToken;
  String createdAt;
  String updatedAt;
  City cities;

  User({
    this.id,
    this.email,
    this.cities,
    this.username,
    this.name,
    this.mobile,
    this.city,
    this.gender,
    this.isVerified,
    this.firebaseToken,
    this.createdAt,
    this.image,
    this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    name = json['name'];
    mobile = json['mobile'];
    image = json['image'];
    city = json['city'];
    if (json['cities'] != null) cities = City.fromJson(json['cities']);
    gender = json['gender'];
    isVerified = json['isVerified'];
    firebaseToken = json['firebaseToken'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['name'] = this.name;
    if (cities != null) data['cities'] = this.cities.toJson();
    data['mobile'] = this.mobile;
    data['city'] = this.city;
    data['image'] = this.image;
    data['gender'] = this.gender;
    data['isVerified'] = this.isVerified;
    data['firebaseToken'] = this.firebaseToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
