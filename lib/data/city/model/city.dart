import 'package:justcost/data/city/model/country.dart';

class CityResponse {
  bool success;
  List<City> data;
  String message;

  CityResponse({this.success, this.data, this.message});

  CityResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<City>();
      json['data'].forEach((v) {
        data.add(new City.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}
